module Ast
  class ExpressionList < Expression
#    attr_reader  :expressions
    def compile method , message
      expressions.collect { |part|  part.compile( method, message ) }
    end
  end
end