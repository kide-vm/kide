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
      puts "compiled return expression #{expression_value.inspect}, now return in 7"
      # copied from function expression: TODO make function

      return_reg = Vm::Integer.new(7)
      if expression_value.is_a?(Vm::IntegerConstant) or expression_value.is_a?(Vm::StringConstant)
        return_reg.load into , expression_value 
      else
        return_reg.move( into, expression_value ) if expression_value.register != return_reg.register
      end
      #function.set_return return_reg
      return return_reg
    end
  end

  
end