module Ast
  class ReturnExpression < Expression
    attr_reader  :expression
    def initialize expression
      @expression = expression
    end
    def inspect
      self.class.name + ".new(" + expression.inspect + " )"  
    end
    def to_s
      "return #{expression}\n"
    end
    def attributes
      [:expression]
    end
    def compile context , into
      expression_value = expression.compile(context , into)
      puts "compiled return expression #{expression_value.inspect}"
      return expression_value
    end
  end

  
end