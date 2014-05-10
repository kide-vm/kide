# collection of the simple ones, int and strings and such

module Ast

  class IntegerExpression < Expression
    attr_reader :value
    def initialize val
      @value = val
    end
    def compile context
      Vm::Signed.new value
    end
    def == other
      compare other , [:value]
    end
  end

  class NameExpression < Expression
    attr_reader  :name
    def initialize name
      @name = name
    end
    def == other
      compare other ,  [:name]
    end
  end

  class StringExpression < Expression
    attr_reader  :string
    def initialize str
      @string = str
    end

    def compile context
      value = Vm::StringLiteral.new(string)
      context.program.add_object value 
      value
    end
    def == other
      compare other ,  [:string]
    end
  end

end