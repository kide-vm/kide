module Ast
  class ExpressionList < Expression
#    attr_reader  :expressions
    def compile binding
      expressions.collect { |part|  part.compile( binding ) }
    end
  end
end