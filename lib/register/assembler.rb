
module Register
  class LinkSlot
    def initialize 
      @position = -1
      @length = -1
    end
    attr_accessor :position , :length , :layout
  end

  # Assmble the object space into a binary.
  # Link first to get positions, then assemble
  # link and assemble functions for each class are close to each other, so to get them the same.
  #  meaning: as the link function determines the length of an object and the assemble actually writes the bytes
  #           they are pretty much dependant. In an earlier version they were functions on the objects, but now it
  #           has gone to a visitor pattern.
  class Assembler

    def initialize space
      @space = space
      @objects = {}
    end

    def link
      link_object(@space)
      at = 0
      @objects.each do |id , slot|
        slot.position = at
        at += slot.length
      end
    end

    def assemble
      link
      @stream = StringIO.new
      assemble_object( @space )
      puts "leng #{@stream.length}"
    end

    def link_object(object)
      slot = @objects[object.object_id]
      unless slot
        slot = LinkSlot.new
        @objects[object.object_id] = slot
      end
      slot.layout =  layout_for(object)
      clazz = object.class.name.split("::").last
      slot.length = send("link_#{clazz}".to_sym , object)
    end

    def assemble_object object
      slot = get_slot(object)
      raise "Object not linked #{object_id}=>#{object.class}" unless slot
      clazz = object.class.name.split("::").last
      send("assemble_#{clazz}".to_sym , object)
    end

    def link_layout(object)
      slot = get_slot(object)
      layout = slot.layout
      length = link_object(layout[:names])
      padded( layout[:names].length)
    end

    # write type and layout of the instance, and the variables that are passed
    # variables ar values, ie int or refs. For refs the object needs to save the object first
    def assemble_self( object , variables )
      slot = get_slot(object)
      raise "Object not linked #{object.inspect}" unless slot
      layout = slot.layout
      @stream.write_uint32( 0 ) #TODO types
      @stream.write_uint32( assemble_object(layout[:names]) ) #ref
      variables.each do |var|
        @stream.write_uint32 var
      end
      ## padding to the nearest 8
      ((padded(variables.length) - variables)/4).times do
        @stream.write_uint32 0
      end
      slot.position
    end

    def link_Array( array )
      # also array has constant overhead, the padded helper fixes it to multiple of 8
      array.each do |elem| 
        link_object(elem)
      end
      padded(array.length)
    end

    def assemble_Array array
      slot = get_slot(array)
      raise "Array not linked #{object.inspect}" unless slot
      layout = slot.layout
      @stream.write_uint32( 0 ) #TODO types
      @stream.write_uint32( assemble_object(layout[:names]) ) #ref
      array.each do |var|
        write_ref(var)
      end
      ## padding to the nearest 8
      ((padded(array.length) - array.length)/4).times do
        @stream.write_uint32 0
      end
      slot.position
    end

    def link_Hash( hash )
      link_object(hash.keys)
      link_object(hash.values)
      link_layout(hash)
      padded(2)
    end

    def assemble_Hash hash
      assemble_self( hash , [ hash.keys , hash.values] )
    end

    def link_BootSpace(space)
      link_object( space.classes)
      link_object(space.objects)
      padded( 2 )
    end

    def assemble_BootSpace(space)
      assemble_self(space , [space.classes,space.objects] )
    end

    def link_BootClass(clazz)
      link_object(clazz.name )
      link_object(clazz.super_class_name)
      link_object(clazz.instance_methods)
      padded(3)
    end

    def assemble_BootClass(clazz)
      assemble_object(clazz.name)
      assemble_object(clazz.super_class_name)
      clazz.instance_methods.each do |meth|
        assemble_object(meth)
      end
    end

    def link_CompiledMethod(method)
      length = 0
      # NOT an ARRAY, just a bag of bytes
      method.blocks.each do |block|
        block.codes.each do |code|
          length += code.length
        end
      end
      padded(length)
    end


    def assemble_CompiledMethod(method)
      assemble_object(method.name)
      method.blocks.each do |block|
        block.codes.each do |code|
          code.assemble( @stream , self )
        end
      end
    end

    def link_String( str)
      return padded(str.length / 4)
    end

    def link_Symbol(sym)
      return link_String(sym.to_s)
    end

    def link_StringConstant( sc)
      return link_String(sc.string)
    end

    def assemble_String( str )
      @stream.write str
    end

    def assemble_Symbol(sym)
      return assemble_String(sym.to_s)
    end

    def assemble_StringConstant( sc)
      return assemble_String(sc.string)
    end

    private 
    def get_slot(object)
      @objects[object.object_id]      
    end

    def write_ref object
      slot = get_slot(object)
      raise "Object not linked #{object.inspect}" unless slot
      @stream.write_uint32 slot.position
    end

    # objects only come in lengths of multiple of 8
    # but there is a constant overhead of 2, one for type, one for layout
    # and as we would have to subtract 1 to make it work without overhead, we now have to add 1
    def padded len
      8 * (1 + (len + 1) / 8)
    end

    def layout_for(object)
      case object
      when Array , Symbol , String , Virtual::CompiledMethod , Virtual::Block , Virtual::StringConstant
        { :names => [] , :types => []}
      when Hash
        { :names => [:keys,:values] , :types => [Virtual::Reference,Virtual::Reference]}
      when Virtual::BootClass
        { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
      when Virtual::BootSpace
        { :names => [:classes,:objects] , :types => [Virtual::Reference,Virtual::Reference]}
      else
        raise "linker encounters unknown class #{object.class}"
      end
    end
  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
