module Ast
  class ExpressionList < Expression
#    attr_reader  :expressions
    def compile method , frame
      expressions.collect { |part|  part.compile( method, frame ) }
    end
  end
end