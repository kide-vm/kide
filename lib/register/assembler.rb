module Register
  class LinkSlot
    def initialize at
      @position = position
      @length = 0
    end
    attr_accessor :position , :length
  end
  class Assembler

    def initialize space
      @space = space
      @objects = {}
    end

    def link
      link_object(@space , 0)
    end

    def link_object(object , at)
      slot = @objects[object.object_id]
      unless slot
        slot = LinkSlot.new at
        @objects[object.object_id] = slot
      end
      if object.is_a? Instruction
        clazz = object.class.name.split("::").last
        len = send("link_#{clazz}".to_sym , object , at)
      else
        len = 4
      end 
      slot.length = len
      len
    end

    def link_BootSpace(space , at)
      len = 0
      space.classes.values.each do |cl|
        len += link_object(cl , at + len)
      end
      len
    end

    def link_BootClass(clazz , at)
      len = link_object(clazz.name , at)
      len += link_object(clazz.super_class_name , at + len)
      clazz.instance_methods.each do |meth|
        len += link_object(meth , at + len)
      end
      len
    end

    def link_MethodDefinition(method , at)
      len = link_object method.name ,at
      method.blocks.each do |block|
        link_object( block , at + len)
      end
      len
    end

    def link_Block(block , at)
      len = 0 
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

  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
