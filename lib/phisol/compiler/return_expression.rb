module Phisol
  Compiler.class_eval do

#    return attr_reader  :expression
    def on_return expression
      return process(expression.to_a.first )
    end
  end
end
