module Ast
  class ReturnExpression < Expression
#    attr_reader  :expression
    def compile context , into
      puts "compiling return expression #{expression}, now return in 7"
      expression_value = expression.compile(context , into)
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