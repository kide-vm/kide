module Register
  class LinkException < Exception
  end
  # Assemble the object space into a binary.
  # Link first to get positions, then assemble

  # The link function determines the length of an object and the assemble actually
  #  writes the bytes they are pretty much dependant. In an earlier version they were
  #  functions on the objects, but now it has gone to a visitor pattern.

  class Assembler
    TYPE_REF =  0
    TYPE_INT =  1
    TYPE_BITS = 4
    TYPE_LENGTH = 6

    def initialize space
      @space = space
    end
    attr_reader :objects

    def link
      # want to have the methods first in the executable
      # so first we determine the code length for the methods and set the
      # binary code (array) to right length
      @space.objects.each do |objekt|
        next unless objekt.is_a? Parfait::Method
        objekt.code.set_length(objekt.info.mem_length / 4 , 0)
      end
      at = 0
      # then we make sure we really get the binary codes first
      @space.objects.each do |objekt|
        next unless objekt.is_a? Parfait::BinaryCode
        objekt.set_position at
        at += objekt.mem_length
      end
      # and then everything else
      @space.objects.each do | objekt|
        # have to tell the code that will be assembled where it is to
        # get the jumps/calls right
        if objekt.is_a? Parfait::Method
          objekt.info.set_position( objekt.code.position )
        end
        next if objekt.is_a? Parfait::BinaryCode
        objekt.set_position at
        at += objekt.mem_length
      end
    end

    def assemble
      #slightly analogous to the link
      begin
        link
        # first we need to create the binary code for the methods
        @space.objects.each do |objekt|
          next unless objekt.is_a? Parfait::Method
          assemble_binary_method(objekt)
        end
        @stream = StringIO.new
        #TODOmid , main = @objects.find{|k,objekt| objekt.is_a?(Virtual::CompiledMethod) and (objekt.name == :__init__ )}
#        initial_jump = @space.init
#        initial_jump.codes.each do |code|
#          code.assemble( @stream )
#        end
        # then write the methods to file
        @space.objects.each do |objekt|
          next unless objekt.is_a? Parfait::BinaryCode
          assemble_any( objekt )
        end
        # and then the rest of the object space
        @space.objects.each do | objekt|
          next if objekt.is_a? Parfait::BinaryCode
          assemble_any( objekt )
        end
      rescue LinkException
        # knowing that we fix the problem, we hope to get away with retry.
        retry
      end
      puts "Assembled 0x#{@stream.length.to_s(16)}/#{@stream.length} bytes"
      return @stream.string
    end

    # assemble the CompiledMethodInfo into a stringio
    # and then plonk that binary data into the method.code array
    def assemble_binary_method method
      stream = StringIO.new
      method.info.blocks.each do |block|
        block.codes.each do |code|
          code.assemble( stream )
        end
      end
      method.code.fill_with 0
      index = 1
      stream.each_byte do |b|
        method.set_char(index , b )
        index = index + 1
        raise "length error #{method.code.get_length}" if index > method.info.get_length
      end
    end
    def assemble_any obj
      puts "Assemble #{obj.class}(\n#{obj.to_s[0..500]}) at stream #{(@stream.length).to_s(16)} pos:#{obj.position.to_s(16)} , len:#{obj.mem_length}"
      if @stream.length != obj.position
        raise "Assemble #{obj.class} at #{@stream.length.to_s(16)} not #{obj.position.to_s(16)}"
      end
      clazz = obj.class.name.split("::").last
      send("assemble_#{clazz}".to_sym , obj)
      obj.position
    end

    def type_word array
      word = 0
      array.each_with_index do |var , index|
        type = (var.class == Integer) ? TYPE_INT : TYPE_REF
        word +=  type << (index * TYPE_BITS)
      end
      word += ( (array.length + 1 ) / 8 ) << TYPE_LENGTH * TYPE_BITS
      word
    end

    # write type and layout of the instance, and the variables that are passed
    # variables ar values, ie int or refs. For refs the object needs to save the object first
    def assemble_self( object , variables )
      unless @objects[object.object_id]
        raise "Object(#{object.object_id}) not linked #{object.inspect}"
      end
      type = type_word(variables)
      @stream.write_uint32( type )
      write_ref_for(object.layout[:names] )
      variables.each do |var|
        raise object.class.name unless var
        write_ref_for(var)
      end
      pad_after( variables.length * 4 )
      object.position
    end

    def assemble_List array
      type = type_word(array)
      @stream.write_uint32( type )
      write_ref_for(array.layout[:names])  #ref
      array.each do |var|
        write_ref_for(var)
      end
      pad_after( array.length * 4 )
      array.position
    end

    def assemble_Dictionary hash
      # so here we can be sure to have _identical_ keys/values arrays
      assemble_self( hash , [ hash.keys , hash.values ] )
    end

    def assemble_Space(space)
      assemble_self(space , [space.classes,space.objects, space.symbols,space.messages,space.next_message,space.next_frame] )
    end

    def assemble_Class(clazz)
      assemble_self( clazz , [clazz.name , clazz.super_class_name, clazz.instance_methods] )
    end

    def assemble_Message me
      assemble_self(me , [])
    end
    def assemble_Frame me
      assemble_self(me , [])
    end

    def assemble_Method(method)
      count = method.info.blocks.inject(0) { |c , block| c += block.mem_length }
      word = (count+7) / 32  # all object are multiple of 8 words (7 for header)
      raise "Method too long, splitting not implemented #{method.name}/#{count}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      write_ref_for(method.get_layout())  #ref of layout
      # TODO the assembly may have to move to the object to be more extensible
      method.blocks.each do |block|
        block.codes.each do |code|
          code.assemble( @stream )
        end
      end
      pad_after( count )
    end

    def assemble_BinaryCode code
        assemble_String code
    end

    def assemble_String( string )
      str = string.to_s if string.is_a? Parfait::Word
      str = string.to_s if str.is_a? Symbol
      word = (str.length + 7) / 32  # all object are multiple of 8 words (7 for header)
      raise "String too long (implement split string!) #{word}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      write_ref_for( string.get_layout ) #ref
      @stream.write str
      pad_after(str.length)
      #puts "String (#{slot.mem_length}) stream #{@stream.mem_length.to_s(16)}"
    end

    def assemble_Symbol(sym)
      return assemble_String(sym)
    end

    def assemble_StringConstant( sc)
      return assemble_String(sc)
    end

    private

    # write means we write the resulting address straight into the assembler stream
    # object means the object of which we write the address
    def write_ref_for object
      @stream.write_sint32 object.position
    end

    # objects only come in lengths of multiple of 8 words
    # but there is a constant overhead of 2 words, one for type, one for layout
    # and as we would have to subtract 1 to make it work without overhead, we now have to add 7
    def padded len
      a = 32 * (1 + (len + 7)/32 )
      #puts "#{a} for #{len}"
      a
    end

    def padded_words words
      padded(words*4) # 4 == word length, a constant waiting for a home
    end

    # pad_after is always in bytes and pads (writes 0's) up to the next 8 word boundary
    def pad_after length
      pad = padded(length) - length - 8 # for header, type and layout
      pad.times do
        @stream.write_uint8(0)
      end
      #puts "padded #{length} with #{pad} stream pos #{@stream.length.to_s(16)}"
    end

  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
