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

    def assemble
      link
      @stream = StringIO.new
      assemble_object( @space )
      puts "leng #{@stream.length}"
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
        object_length = 0 #link_self(object , at)
        total_length = object_length + send("link_#{clazz}".to_sym , object , at + object_length)
      end
      slot.length = total_length
      total_length
    end

    def assemble_object object
      slot = @objects[object.object_id]
      raise "Object not linked #{object_id}" unless slot
      if object.is_a? Instruction
        object.assemble( @stream , self )
      else
        clazz = object.class.name.split("::").last
        len = send("assemble_#{clazz}".to_sym , object)
      end
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

    def assemble_BootSpace(space)
      # assemble in the same order as linked
      space.classes.values.each do |cl|
        assemble_object(cl)
      end
      space.objects.each do |o|
        assemble_object(o)
      end
    end

    def link_BootClass(clazz , at)
      length = link_object(clazz.name , at)
      length += link_object(clazz.super_class_name , at + length)
      length + link_Array(clazz.instance_methods , at + length)
    end

    def assemble_BootClass(clazz)
      assemble_object(clazz.name)
      assemble_object(clazz.super_class_name)
      clazz.instance_methods.each do |meth|
        assemble_object(meth)
      end
    end

    def link_MethodDefinition(method , at)
      length = link_object(method.name ,at)
      length + link_Array(method.blocks ,at + length)
    end

    def assemble_MethodDefinition(method)
      assemble_object(method.name)
      method.blocks.each do |block|
        assemble_object(block)
      end
    end

    def link_Block(block , at)
      len = 0 
      block.codes.each do |code|
        len += link_object(code , at + len)
      end
      len
    end

    def assemble_Block(block)
      block.codes.each do |code|
        assemble_object(code)
      end
    end

    def link_String( str , at)
      return (str.length / 4) + 1 + 2
    end

    def assemble_String( str )
      @stream.write str
    end

    def link_Symbol(sym , at)
      return link_String(sym.to_s , at)
    end

    def assemble_Symbol(sym)
      return assemble_String(sym.to_s)
    end

    def link_StringConstant( sc , at)
      return link_String(sc.string,at)
    end
    def assemble_StringConstant( sc)
      return assemble_String(sc.string)
    end
  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
