module Bosl
  module Compiler

#    return attr_reader  :expression
    def self.compile_return expression, method
      return Compiler.compile(expression.to_a.first , method)
    end
  end
end
