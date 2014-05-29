module Ast
  class ModuleExpression < Expression
    attr_reader  :name ,:expressions
    def initialize name , expressions
      @name = name.to_sym
      @expressions = expressions
    end
    def inspect
      self.class.name + ".new(" + @name.inspect + " ," + @expressions.inspect + " )"  
    end
    def to_s
      "module #{name}\n #{expressions}\nend\n"
    end
    def attributes
      [:name , :expressions]
    end
    def compile context , into
      expression_value = expression.compile(context , into)
      puts "compiled return expression #{expression_value.inspect}, now return in 7"
      # copied from function expression: TODO make function

      return_reg = Vm::Integer.new(7)
      if expression_value.is_a?(Vm::IntegerConstant) or expression_value.is_a?(Vm::StringConstant)
        return_reg.load into , expression_value if expression_value.register != return_reg.register
      else
        return_reg.move( into, expression_value ) if expression_value.register != return_reg.register
      end
      #function.set_return return_reg
      return return_reg
    end
  end

  
end