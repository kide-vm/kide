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
        total_length = 4
      else
        clazz = object.class.name.split("::").last
        object_length = link_self(object , at)
        total_length = object_length + send("link_#{clazz}".to_sym , object , at + object_length)
      end
      slot.length = total_length
      total_length
    end

    def link_self(object , at)
      puts "Object #{object.class}"
      0
    end

    def link_Array( array , at)
      length = 0
      array.each do |elem| 
        length += link_object(elem , at + length)
      end
      length
    end

    def link_BootSpace(space , at)
      length = link_Array( space.classes.values , at )
      length + link_Array(space.objects , at + length)
    end

    def link_BootClass(clazz , at)
      length = link_object(clazz.name , at)
      length += link_object(clazz.super_class_name , at + length)
      length + link_Array(clazz.instance_methods , at + length)
    end

    def link_MethodDefinition(method , at)
      length = link_object(method.name ,at)
      # NOT an ARRAY
      length + link_Array(method.blocks ,at + length)
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
    
  end
end