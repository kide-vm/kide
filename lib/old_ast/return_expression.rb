module Ast
  class ReturnExpression < Expression
#    attr_reader  :expression
    def compile context
      into = context.function
      puts "compiling return expression #{expression}, now return in return_regsiter"
      expression_value = expression.compile(context)
      # copied from function expression: TODO make function

      return_reg = Vm::Integer.new(Vm::RegisterMachine.instance.return_register)
      if expression_value.is_a?(Vm::IntegerConstant) or expression_value.is_a?(Vm::ObjectConstant)
        return_reg.load into , expression_value 
      else
        return_reg.move( into, expression_value ) if expression_value.register_symbol != return_reg.register_symbol
      end
      #function.set_return return_reg
      return return_reg
    end
  end

  
end