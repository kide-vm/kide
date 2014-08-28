module Register
  class LinkSlot
    def initialize at
      @position = position
      @length = 0
    end
    attr_accessor :position , :length
  end
  class Linker
    def initialize
      @objects = {}
    end

    def get_slot(object)
      @objects[object.object_id]      
    end

    def link_object(object , at)
      slot = @objects[object.object_id]
      unless slot
        slot = LinkSlot.new at
        @objects[object.object_id] = slot
      end
      if object.is_a? Instruction
        length = 4
      else
        clazz = object.class.name.split("::").last
        length = send("link_#{clazz}".to_sym , object , at)
      end
      slot.length = length
      length
    end

    def link_Array( array , at)
      length = 0
      array.each do |elem| 
        length += link_object(elem , at + length)
      end
      # also array has constant overhead, the members helper fixes it to multiple of 8
      members(length)
    end

    def link_BootSpace(space , at)
      length = members( 2 )
      length += link_Array( space.classes.values , at + length )
      length + link_Array(space.objects , at + length)
    end

    def link_BootClass(clazz , at)
      length = members(3)
      length += link_object(clazz.name , at + length)
      length += link_object(clazz.super_class_name , at + length)
      length + link_Array(clazz.instance_methods , at + length)
    end

    def link_CompiledMethod(method , at)
      length = members(2)
      length += link_object(method.name ,at + length)
      # NOT an ARRAY, just a bag of bytes
      method.blocks.each do |block|
        length += link_object( block ,at + length)
      end
      length
    end

    def link_Block(block , at)
      len = 0 
      # NOT linking as an array, as we need the strem that makes the method
      block.codes.each do |code|
        len += link_object(code , at + len)
      end
      len
    end
    
    def link_String( str , at)
      return (str.length / 4) + 1 + 2
    end

    def link_Symbol(sym , at)
      return link_String(sym.to_s , at)
    end

    def link_StringConstant( sc , at)
      return link_String(sc.string,at)
    end
    
    
    # objects only come in lengths of multiple of 8
    # but there is a constant overhead of 2, one for type, one for layout
    # and as we would have to subtract 1 to make it work without overhead, we now have to add 1
    def members len
      8 * (1 + (len + 1) / 8)
    end
    
  end
end