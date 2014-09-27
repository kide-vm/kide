module Register
  class LinkException < Exception
  end
  # Assmble the object space into a binary.
  # Link first to get positions, then assemble
  # link and assemble functions for each class are close to each other, so to get them the same.
  #  meaning: as the link function determines the length of an object and the assemble actually writes the bytes
  #           they are pretty much dependant. In an earlier version they were functions on the objects, but now it
  #           has gone to a visitor pattern.
  class Assembler
    TYPE_REF =  0
    TYPE_INT =  1
    TYPE_BITS = 4
    TYPE_LENGTH = 6
    
    def initialize space
      @space = space
      @objects = {}
    end
    attr_reader :objects

    def link
      add_object(@space)
      at = 4  # first jump instruction
      # then all functions
      @objects.each_value do | objekt|
        next unless objekt.is_a? Virtual::CompiledMethod
        objekt.set_position(at)
        at += objekt.mem_length
      end
      #and then all data object
      @objects.each_value do | objekt|
        next if objekt.is_a? Virtual::CompiledMethod
        objekt.set_position at
        at += objekt.mem_length
      end
    end

    def assemble
      begin
        link
        @stream = StringIO.new
        mid , main = @objects.find{|k,objekt| objekt.is_a?(Virtual::CompiledMethod) and (objekt.name == :__init__ )}
        initial_jump = RegisterMachine.instance.b( main )
        initial_jump.set_position( 0)
        initial_jump.assemble( @stream )
        @objects.each_value do |objekt|
          next unless objekt.is_a? Virtual::CompiledMethod
          assemble_object( objekt )
        end
        @objects.each_value do | objekt|
          next if objekt.is_a? Virtual::CompiledMethod
          assemble_object( objekt )
        end
      rescue LinkException => e
        # knowing that we fix the problem, we hope to get away with retry.
        retry
      end
      puts "Assembled 0x#{@stream.length.to_s(16)}/#{@stream.length} bytes"
      return @stream.string
    end

    def assemble_object obj
      #puts "Assemble #{obj.class}(#{obj.object_id}) at stream #{(@stream.length).to_s(16)} pos:#{obj.position.to_s(16)} , len:#{obj.mem_length}" 
      raise "Assemble #{obj.class} at #{@stream.length.to_s(16)} not #{obj.position.to_s(16)}" if @stream.length != obj.position
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
      raise "Object(#{object.object_id}) not linked #{object.inspect}" unless @objects[object.object_id]
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

    def assemble_Array array
      type = type_word(array)
      @stream.write_uint32( type )
      write_ref_for(array.layout[:names])  #ref
      array.each do |var|
        write_ref_for(var)
      end
      pad_after( array.length * 4 )
      array.position
    end

    def assemble_Hash hash
      # so here we can be sure to have _identical_ keys/values arrays
      assemble_self( hash , [ hash.keys , hash.values ] )
    end

    def assemble_BootSpace(space)
      assemble_self(space , [space.classes,space.objects, space.symbols,space.messages,space.next_message,space.next_frame] )
    end

    def assemble_BootClass(clazz)
      assemble_self( clazz , [clazz.name , clazz.super_class_name, clazz.instance_methods] )
    end

    def assemble_Message me
      assemble_self(me , [])
    end
    def assemble_Frame me
      assemble_self(me , [])
    end

    def assemble_CompiledMethod(method)
      count = method.blocks.inject(0) { |c , block| c += block.mem_length }
      word = (count+7) / 32  # all object are multiple of 8 words (7 for header)
      raise "Method too long, splitting not implemented #{method.name}/#{count}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      write_ref_for(method.layout[:names])  #ref of layout
      # TODO the assembly may have to move to the object to be more extensible
      method.blocks.each do |block|
        block.codes.each do |code|
          code.assemble( @stream )
        end
      end
      pad_after( count )
    end

    def assemble_String( str )
      str = str.string if str.is_a? Virtual::StringConstant
      str = str.to_s if str.is_a? Symbol
      word = (str.length + 7) / 32  # all object are multiple of 8 words (7 for header)
      raise "String too long (implement split string!) #{word}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      write_ref_for( str.layout[:names] ) #ref
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

    def add_object(object)
      return if @objects[object.object_id]
      @objects[object.object_id] = object
      add_object(object.layout[:names])
      clazz = object.class.name.split("::").last
      send("add_#{clazz}".to_sym , object)
    end

    def add_Message m
    end
    def add_Frame f
    end
    def add_Array( array )
      # also array has constant overhead, the padded helper fixes it to multiple of 8
      array.each do |elem| 
        add_object(elem)
      end
    end

    def add_Hash( hash )
      add_object(hash.keys)
      add_object(hash.values)
    end

    def add_BootSpace(space)
      add_object(space.classes)
      add_object(space.objects)
      add_object(space.symbols)
      add_object(space.messages)
      add_object(space.next_message)
      add_object(space.next_frame)
    end

    def add_BootClass(clazz)
      add_object(clazz.name )
      add_object(clazz.super_class_name)
      add_object(clazz.instance_methods)
    end
    def add_CompiledMethod(method)
      add_object(method.name)
    end
    def add_String( str)
    end
    def add_Symbol(sym)
    end
    def add_StringConstant(sc)
    end

    private 

    # write means we write the resulting address straight into the assembler stream (ie don't return it)
    # object means the object of which we write the address
    # and we write the address into the self, given as second parameter
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
