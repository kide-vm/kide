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

    # compiling a variable resolves it. 
    # if it wasn't defined, nli is returned 
    def compile context , into
      context.locals[name]
    end
  end

  class ModuleName < NameExpression
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