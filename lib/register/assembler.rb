require_relative "linker"

module Register
  class Assembler

    def initialize space
      @space = space
      @linker = Linker.new()
    end

    def link
      @linker.link_object(@space , 0)
    end

    def get_slot(object)
      @linker.get_slot(object)
    end

    def assemble
      link
      @stream = StringIO.new
      assemble_object( @space )
      puts "leng #{@stream.length}"
    end

    def assemble_object object
      slot = get_slot(object)
      raise "Object not linked #{object_id}" unless slot
      if object.is_a? Instruction
        object.assemble( @stream , self )
      else
        clazz = object.class.name.split("::").last
        len = send("assemble_#{clazz}".to_sym , object)
      end
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

    def assemble_BootClass(clazz)
      assemble_object(clazz.name)
      assemble_object(clazz.super_class_name)
      clazz.instance_methods.each do |meth|
        assemble_object(meth)
      end
    end

    def assemble_MethodDefinition(method)
      assemble_object(method.name)
      method.blocks.each do |block|
        assemble_object(block)
      end
    end

    def assemble_Block(block)
      block.codes.each do |code|
        assemble_object(code)
      end
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
  end

  Sof::Volotile.add(Register::Assembler , [:objects])
end
