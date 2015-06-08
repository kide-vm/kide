module Register
  class LinkException < Exception
  end
  # Assemble the object machine into a binary.
  # Link first to get positions, then assemble

  # The link function determines the length of an object and the assemble actually
  #  writes the bytes they are pretty much dependant. In an earlier version they were
  #  functions on the objects, but now it has gone to a visitor pattern.

  class Assembler
    include Padding
    TYPE_REF =  0
    TYPE_INT =  1
    TYPE_BITS = 4
    TYPE_LENGTH = 6

    def initialize machine
      @machine = machine
    end

    def link
      # want to have the methods first in the executable
      # so first we determine the code length for the methods and set the
      # binary code (array) to right length
      @machine.objects.each do |objekt|
        next unless objekt.is_a? Parfait::Method
        objekt.code.set_length(objekt.info.byte_length , 0)
      end
      at = 0
      # then we make sure we really get the binary codes first
      @machine.objects.each do |objekt|
        next unless objekt.is_a? Parfait::BinaryCode
        objekt.set_position at
        # puts "CODE #{objekt.name} at #{objekt.position}"
        at += objekt.word_length
      end
      # and then everything else
      @machine.objects.each do | objekt|
        # have to tell the code that will be assembled where it is to
        # get the jumps/calls right
        if objekt.is_a? Parfait::Method
          objekt.info.set_position( objekt.code.position )
        end
        next if objekt.is_a? Parfait::BinaryCode
        objekt.set_position at
        at += objekt.word_length
      end
    end

    def assemble
      # must be same order as link

      begin
        link
        all= @machine.objects.sort{|a,b| a.position <=> b.position}
        # debugging loop accesses all positions to force an error if it's not set
        all.each do |objekt|
          puts "Linked #{objekt.class}(#{objekt.object_id.to_s(16)}) at #{objekt.position.to_s(16)} / #{objekt.word_length.to_s(16)}"
          objekt.position
        end
        # first we need to create the binary code for the methods
        @machine.objects.each do |objekt|
          next unless objekt.is_a? Parfait::Method
          assemble_binary_method(objekt)
        end
        @stream = StringIO.new
        #TODOmid , main = @objects.find{|k,objekt| objekt.is_a?(Virtual::CompiledMethod) and (objekt.name == :__init__ )}
#        initial_jump = @machine.init
#        initial_jump.codes.each do |code|
#          code.assemble( @stream )
#        end
        # then write the methods to file
        @machine.objects.each do |objekt|
          next unless objekt.is_a? Parfait::BinaryCode
          assemble_any( objekt )
        end
        # and then the rest of the object machine
        @machine.objects.each do | objekt|
          next if objekt.is_a? Parfait::BinaryCode
          assemble_any( objekt )
        end
      rescue LinkException
        puts "RELINK"
        # knowing that we fix the problem, we hope to get away with retry.
        retry
      end
      puts "Assembled 0x#{@stream.length.to_s(16)}/#{@stream.length.to_s(16)} bytes"
      return @stream.string
    end

    # assemble the CompiledMethodInfo into a stringio
    # and then plonk that binary data into the method.code array
    def assemble_binary_method method
      stream = StringIO.new
      method.info.blocks.each do |block|
        block.codes.each do |code|
          begin
          code.assemble( stream )
        rescue => e
            puts "Method error #{method.name}\n#{Sof::Writer.write(method.info.blocks).to_s[0...2000]}"
            puts Sof::Writer.write(code)
            raise e
          end
        end
      end
      method.code.fill_with 0
      index = 1
      stream.rewind
      puts "Assembled #{method.name} with length #{stream.length}"
      raise "length error #{method.code.length} != #{method.info.byte_length}" if method.code.length != method.info.byte_length
      raise "length error #{stream.length} != #{method.info.byte_length}" if method.info.byte_length - stream.length > 32
      stream.each_byte do |b|
        method.code.set_char(index , b )
        index = index + 1
      end
    end

    def assemble_any obj
      puts "Assemble #{obj.class}(#{obj.object_id.to_s(16)}) at stream #{@stream.length.to_s(16)} pos:#{obj.position.to_s(16)} , len:#{obj.word_length.to_s(16)}"
      if @stream.length != obj.position
        raise "Assemble #{obj.class} #{obj.object_id.to_s(16)} at #{@stream.length.to_s(16)} not #{obj.position.to_s(16)}"
      end
      clazz = obj.class.name.split("::").last
      send("assemble_#{clazz}".to_sym , obj)
      obj.position
    end

    def type_word array
      word = 0
      index = 0
      array.each do |var |
        #type = (var.class == Integer) ? TYPE_INT : TYPE_REF
        #TODO
        type = TYPE_REF
        word += type << (index * TYPE_BITS)
        index = index + 1
      end
      word += ( (array.get_length + 1 ) / 8 ) << TYPE_LENGTH * TYPE_BITS
      word
    end

    # write type and layout of the instance, and the variables that are passed
    # variables ar values, ie int or refs. For refs the object needs to save the object first
    def assemble_object( object )
      unless @machine.objects.include? object
        raise "Object(#{object.object_id}) not linked #{object.inspect}"
      end
      layout = object.get_layout
      type = type_word(layout)
      @stream.write_uint32( type )
      write_ref_for(layout )
      layout.each do |var|
        inst = object.instance_variable_get "@#{var}".to_sym
        puts "Nil for #{object.class}.#{var}" unless inst
        write_ref_for(inst)
      end
      puts "layout length=#{layout.get_length.to_s(16)} mem_len=#{layout.word_length.to_s(16)}"
      l = layout.get_length
      if( object.is_a? Parfait::List)
        object.each do |inst|
          write_ref_for(inst)
        end
        l += object.get_length
      end
      pad_after( l * 4)
      object.position
    end

    def assemble_List array
      assemble_object array
      return

      type = type_word(array)
      @stream.write_uint32( type )
      write_ref_for(array.layout[:names])  #ref
      array.each do |var|
        write_ref_for(var)
      end
      pad_after( array.length * 4 )
      array.position
    end

    def assemble_Layout layout
        assemble_object(layout)
    end
    def assemble_Dictionary hash
      # so here we can be sure to have _identical_ keys/values arrays
      assemble_object( hash )
    end

    def assemble_Space(space)
      assemble_object(space )
    end

    def assemble_Class(clazz)
      assemble_object( clazz )
    end

    def assemble_Message me
      assemble_object(me)
    end
    def assemble_Frame me
      assemble_object(me )
    end

    def assemble_Method(method)
      assemble_object(method)
      return
      count = method.info.blocks.inject(0) { |c , block| c += block.word_length }
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
      str = string.to_string if string.is_a? Parfait::Word
      str = string.to_s if string.is_a? Symbol
      word = (str.length + 7) / 32  # all object are multiple of 8 words (7 for header)
      raise "String too long (implement split string!) #{word}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      puts "String is #{string} at #{string.position.to_s(16)} length #{string.length.to_s(16)}"
      write_ref_for( string.get_layout ) #ref
      @stream.write str
      pad_after(str.length)
      #puts "String (#{slot.word_length}) stream #{@stream.word_length.to_s(16)}"
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
      if object.nil?
        pos = 0
      else
        pos =  object.position
      end
      @stream.write_sint32 pos
    end

    # pad_after is always in bytes and pads (writes 0's) up to the next 8 word boundary
    def pad_after length
      before = @stream.length.to_s(16)
      pad = padding_for(length)
      pad.times do
        @stream.write_uint8(0)
      end
      after = @stream.length.to_s(16)
      puts "padded #{length.to_s(16)} with #{pad.to_s(16)} stream #{before}/#{after}"
    end

  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
