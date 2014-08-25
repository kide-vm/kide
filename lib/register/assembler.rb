module Register
  class LinkSlot
    def initialize at
      @position = position
    end
    attr_accessor :position
  end
  class Assembler

    def initialize space
      @space = space
      @objects = {}
    end

    def link at = 0
      link_object @space , at
    end

    def link_object object , at
      slot = @objects[object.object_id]
      unless slot
        slot = LinkSlot.new at
        @objects[object.object_id] = slot
      end
      return if object.is_a? Instruction
      clazz = object.class.name.split("::").last
      send("link_#{clazz}".to_sym , object , at)
    end

    def link_BootSpace space , at
      space.classes.values.each do |cl|
        link_object cl , at
      end
    end

    def link_BootClass clazz , at
      link_object clazz.name , at
      link_object clazz.super_class_name , at
      clazz.instance_methods.each do |meth|
        link_object meth , at
      end
    end
    def link_MethodDefinition method , at
      link_object method.name ,at
      method.blocks.each do |block|
        link_object block , at
      end
    end
    def link_Block block , at
      block.codes.each do |code|
        link_object code , at
      end
    end
    def link_MethodEnter str , at    
    end
    def link_MethodReturn str , at    
    end
    def link_FunctionCall str , at    
    end
    def link_String str , at    
    end
    def link_Symbol sym , at    
    end
  end
end
