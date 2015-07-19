module Virtual
  module Compiler

#    return attr_reader  :expression
    def self.compile_return expression, method
      return Compiler.compile(expression.expression , method)
    end
  end
end
