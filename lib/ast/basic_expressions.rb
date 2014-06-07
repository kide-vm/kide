# collection of the simple ones, int and strings and such

module Ast

  class IntegerExpression < Expression
#    attr_reader :value
    def compile context , into
      Vm::IntegerConstant.new value
    end
  end

  class NameExpression < Expression
#    attr_reader  :name

    # compiling a variable resolves it. if it wasn't defined, raise an exception 
    def compile context , into
      raise "Undefined variable #{name}, defined locals #{context.locals.keys.join('-')}" unless context.locals.has_key?(name)
      context.locals[name]
    end
  end

  class ModuleName < NameExpression

    def compile context , into
      clazz = context.object_space.get_or_create_class name
      raise "uups #{clazz}.#{name}" unless clazz
      #class qualifier, means call from metaclass
      clazz = clazz.meta_class
      value = clazz
      puts "CLAZZ #{value}"
      function = clazz.get_or_create_function(name)
    end    
  end

  class StringExpression < Expression
#    attr_reader  :string
    def compile context , into
      value = Vm::StringConstant.new(string)
      context.object_space.add_object value 
      value
    end
  end
end