
module Register
  class LinkSlot
    def initialize o 
      @position = -1
      @length = -1
      @object = o
    end
    attr_reader :object
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
        next unless slot.object.is_a? Virtual::CompiledMethod
        slot.position = at
        at += slot.length
      end
      @objects.each do |id , slot|
        next if slot.object.is_a? Virtual::CompiledMethod
        slot.position = at
        at += slot.length
      end
    end

    def assemble
      link
      @stream = StringIO.new
      @objects.each do |id , slot|
        next unless slot.object.is_a? Virtual::CompiledMethod
        assemble_object( slot.object )
      end
      @objects.each do |id , slot|
        next if slot.object.is_a? Virtual::CompiledMethod
        assemble_object( slot.object )
      end
      puts "Assembled #{@stream.length}"
    end

    def link_object(object)
      slot = @objects[object.object_id]
      return slot.length if slot
      slot = LinkSlot.new object
      @objects[object.object_id] = slot
      slot.layout = layout_for(object)
      clazz = object.class.name.split("::").last
      slot.length = send("link_#{clazz}".to_sym , object)
      link_object(slot.layout[:names])
      slot.length
    end

    def assemble_object object
      slot = get_slot(object)
      raise "Object not linked #{object_id}=>#{object.class}, #{object.inspect}" unless slot
      clazz = object.class.name.split("::").last
      send("assemble_#{clazz}".to_sym , slot)
      slot.position
    end

    # write type and layout of the instance, and the variables that are passed
    # variables ar values, ie int or refs. For refs the object needs to save the object first
    def assemble_self( object , variables )
      slot = get_slot(object)
      raise "Object not linked #{object.inspect}" unless slot
      layout = slot.layout
      @stream.write_uint32( 0 ) #TODO types
      write_ref(layout[:names])
      variables.each do |var|
        write_ref var
      end
      ## padding to the nearest 8
      ((padded(variables.length) - variables.length)).times do
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

    def assemble_Array slot
      array = slot.object
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
      slot = get_slot(hash)
      #hook the key/values arrays into the layout (just because it was around)
      link_object(slot.layout[:keys])
      link_object(slot.layout[:values])
      padded(2)
    end

    def assemble_Hash slot
      # so here we can be sure to have _identical_ keys/values arrays
      assemble_self( slot.object , [ slot.layout[:keys] , slot.layout[:values] ] )
    end

    def link_BootSpace(space)
      link_object(space.classes)
      link_object(space.objects)
      padded( 2 )
    end

    def assemble_BootSpace(slot)
      space = slot.object
      assemble_self(space , [space.classes,space.objects] )
    end

    def link_BootClass(clazz)
      link_object(clazz.name )
      link_object(clazz.super_class_name)
      link_object(clazz.instance_methods)
      padded(3)
    end

    def assemble_BootClass(slot)
      clazz = slot.object
      assemble_self( clazz , [clazz.name , clazz.super_class_name, clazz.instance_methods] )
    end

    def link_CompiledMethod(method)
      # NOT an ARRAY, just a bag of bytes
      length = method.blocks.inject(0) { |c , block| c += block.length }
      padded(length)
    end


    def assemble_CompiledMethod(slot)
      method = slot.object
      @stream.write_uint32( 0 ) #TODO types
      write_ref(slot.layout[:names])  #ref of layout
      # TODO the assembly may have to move to the object to be more extensible
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

    def link_StringConstant(sc)
      return link_String(sc.string)
    end

    def assemble_String( str )
      slot = get_slot(str)
      raise "String not linked #{str}" unless slot
      layout = slot.layout
      @stream.write_uint32( 0 ) #TODO types
      @stream.write_uint32( assemble_object(layout[:names]) ) #ref
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
      slot = @objects[object.object_id]
      return slot if slot
      if(object.is_a? Array)
        @objects.each do |k,slot|
          next unless slot.object.is_a? Array
          if(slot.object.length == object.length)
            same = true
            slot.object.each_with_index do |v,index|
              same = false unless v == object[index]
            end
            puts slot.object.first.class if same
            return slot if same
          end
        end
      end
      nil
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

    # class variables to have _identical_ objects passed back (stops recursion)
    @@ARRAY =  { :names => [] , :types => []}
    @@HASH = { :names => [:keys,:values] , :types => [Virtual::Reference,Virtual::Reference]}
    @@CLAZZ = { :names => [:name , :super_class_name , :instance_methods] , :types => [Virtual::Reference,Virtual::Reference,Virtual::Reference]}
    @@SPACE = { :names => [:classes,:objects] , :types => [Virtual::Reference,Virtual::Reference]}

    def layout_for(object)
      case object
      when Array , Symbol , String , Virtual::CompiledMethod , Virtual::Block , Virtual::StringConstant
        @@ARRAY
      when Hash
        @@HASH.merge :keys => object.keys , :values => object.values 
      when Virtual::BootClass
        @@CLAZZ
      when Virtual::BootSpace
        @@SPACE
      else
        raise "linker encounters unknown class #{object.class}"
      end
    end
  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
