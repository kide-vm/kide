module Virtual
  module Compiler

#    return attr_reader  :expression
    def self.compile_return expression, scope ,method
      Virtual::Reference.new
    end
    def old
      into = context.function
      puts "compiling return expression #{expression}, now return in return_regsiter"
      expression_value = expression.compile(context)
      # copied from function expression: TODO make function

      return_reg = Virtual::Integer.new(Virtual::RegisterMachine.instance.return_register)
      if expression_value.is_a?(Virtual::IntegerConstant) or expression_value.is_a?(Virtual::ObjectConstant)
        return_reg.load into , expression_value
      else
        return_reg.move( into, expression_value ) if expression_value.register_symbol != return_reg.register_symbol
      end
      #function.set_return return_reg
      return return_reg
    end
  end
end
