# collection of the simple ones, int and strings and such

module Ast

  class IntegerExpression < Expression
    attr_reader :value
    def initialize val
      @value = val
    end
    def inspect
      self.class.name + ".new(" + value.to_s+ ")"
    end
    def compile context
      Vm::Signed.new value
    end
    def attributes
      [:value]
    end
  end

  class NameExpression < Expression
    attr_reader  :name
    def initialize name
      @name = name
    end
    def compile context
      variable = Vm::Variable.new(@name)
      context.locals[@name] = variable
      variable
    end
    def inspect
      self.class.name + '.new("' + name + '")'
    end
    def attributes
      [:name]
    end
  end

  class StringExpression < Expression
    attr_reader  :string
    def initialize str
      @string = str
    end
    def inspect
      self.class.name + '.new("' + string + '")'
    end

    def compile context
      value = Vm::StringLiteral.new(string)
      context.program.add_object value 
      value
    end
    def attributes
      [:string]
    end
  end

end