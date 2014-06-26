module Ast
  class ExpressionList < Expression
#    attr_reader  :expressions
    def compile binding
      expressions.each do |part|
        expr    = part.compile( binding )
      end
    end
  end
end