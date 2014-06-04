module Ast

  class ArrayExpression < Expression
#    attr_reader :values
    def compile context
      to.do
    end
  end
  class AssociationExpression < Expression
#    attr_reader :key , :value
    def compile context
      to.do
    end
  end
  class HashExpression < ArrayExpression
    def compile context
      to.do
    end
  end
end