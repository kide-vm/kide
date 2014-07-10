module Ast
  class ExpressionList < Expression
#    attr_reader  :expressions
    def compile binding , method
      expressions.collect { |part|  part.compile( binding , method ) }
    end
  end
end