module Register

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
      collect_object(@space)
      at = 4
      @objects.each do |id , objekt|
        next unless objekt.is_a? Virtual::CompiledMethod
        objekt.position = at
        objekt.set_position at
        at += objekt.length
      end
      @objects.each do |id , objekt|
        next if objekt.is_a? Virtual::CompiledMethod
        objekt.position = at
        at += objekt.length
      end
    end

    def assemble
      link
      @stream = StringIO.new
      mid , main = @objects.find{|k,objekt| objekt.is_a?(Virtual::CompiledMethod) and (objekt.name == :__init__ )}
      puts "function found #{main.name}"
      initial_jump = RegisterMachine.instance.b( main )
      initial_jump.position = 0
      initial_jump.assemble( @stream , self )
      @objects.each do |id , objekt|
        next unless objekt.is_a? Virtual::CompiledMethod
        assemble_object( objekt )
      end
      @objects.each do |id , objekt|
        next if objekt.is_a? Virtual::CompiledMethod
        assemble_object( objekt )
      end
      puts "Assembled #{@stream.length.to_s(16)}"
      return @stream.string
    end

    def collect_object(object)
      return object.length if @objects[object.object_id]
      @objects[object.object_id] = object
      collect_object(object.layout[:names])
      clazz = object.class.name.split("::").last
      send("collect_#{clazz}".to_sym , object)
    end

    def assemble_object obj
      puts "Assemble #{obj.class}(#{obj.object_id}) at stream #{(@stream.length).to_s(16)} pos:#{obj.position.to_s(16)} , len:#{obj.length}" 
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
      write_ref_for(object.layout[:names] , object )
      variables.each do |var|
        write_ref_for(var , object)
      end
      pad_after( variables.length * 4 )
      object.position
    end

    def collect_Array( array )
      # also array has constant overhead, the padded helper fixes it to multiple of 8
      array.each do |elem| 
        collect_object(elem)
      end
      padded_words(array.length)
    end

    def assemble_Array array
      type = type_word(array)
      @stream.write_uint32( type )
      write_ref_for(layout[:names],array)  #ref
      array.each do |var|
        write_ref_for(var,array)
      end
      pad_after( array.length * 4 )
      array.position
    end

    def collect_Hash( hash )
      #hook the key/values arrays into the layout (just because it was around)
      collect_object(hash.keys)
      collect_object(hash.values)
      padded_words(2)
    end

    def assemble_Hash hash
      # so here we can be sure to have _identical_ keys/values arrays
      assemble_self( hash , [ hash.layout[:keys] , hash.layout[:values] ] )
    end

    def collect_BootSpace(space)
      collect_object(space.classes)
      collect_object(space.objects)
      padded_words( 2 )
    end

    def assemble_BootSpace(space)
      assemble_self(space , [space.classes,space.objects] )
    end

    def collect_BootClass(clazz)
      collect_object(clazz.name )
      collect_object(clazz.super_class_name)
      collect_object(clazz.instance_methods)
      padded_words(3)
    end

    def assemble_BootClass(clazz)
      assemble_self( clazz , [clazz.name , clazz.super_class_name, clazz.instance_methods] )
    end

    def collect_CompiledMethod(method)
      # NOT an ARRAY, just a bag of bytes
      length = method.blocks.inject(0) { |c , block| c += block.length }
      padded(length)
    end


    def assemble_CompiledMethod(method)
      count = method.blocks.inject(0) { |c , block| c += block.length }
      word = (count+7) / 32  # all object are multiple of 8 words (7 for header)
      raise "Method too long, splitting not implemented #{method.name}/#{count}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      write_ref_for(method.layout[:names] , method)  #ref of layout
      # TODO the assembly may have to move to the object to be more extensible
      method.blocks.each do |block|
        block.codes.each do |code|
          code.assemble( @stream , self )
        end
      end
      pad_after( count )
    end

    def collect_String( str)
      return padded( str.length + 1 )
    end

    def collect_Symbol(sym)
      return collect_String(sym.to_s)
    end

    def collect_StringConstant(sc)
      return collect_String(sc.string)
    end

    def assemble_String( str )
      str = str.string if str.is_a? Virtual::StringConstant
      str = str.to_s if str.is_a? Symbol
      word = (str.length + 7) / 32  # all object are multiple of 8 words (7 for header)
      raise "String too long (implement split string!) #{word}" if word > 15
      # first line is integers, convention is that following lines are the same
      TYPE_LENGTH.times { word = ((word << TYPE_BITS) + TYPE_INT) }
      @stream.write_uint32( word )
      write_ref_for( str.layout[:names] , slot) #ref
      @stream.write str
      pad_after(str.length)
      #puts "String (#{slot.length}) stream #{@stream.length.to_s(16)}"
    end

    def assemble_Symbol(sym)
      return assemble_String(sym)
    end

    def assemble_StringConstant( sc)
      return assemble_String(sc)
    end

    def position_for object
      s = get_slot(object)
      s.position
    end
    private 

    # write means we write the resulting address straight into the assembler stream (ie don't return it)
    # object means the object of which we write the address
    # and we write the address into the self, given as second parameter
    def write_ref_for object , self_ref
      raise "Object (#{object.object_id}) not linked #{object.inspect}" unless slot
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
