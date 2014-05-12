module Ast

  class ArrayExpression < Expression
    attr_reader :values
    def initialize vals
      @values = vals
    end
    def inspect
      self.class.name + ".new(" + values.to_s+ ")"
    end
    def compile context
      to.do
    end
    def attributes
      [:values]
    end
  end
  class AssociationExpression < Expression
    attr_reader :key , :value
    def initialize key , value
      @key , @value = key , value
    end
    def inspect
      self.class.name + ".new(" + key.inspect + " , " + value.inspect + ")"
    end
    def compile context
      to.do
    end
    def attributes
      [:key , :value]
    end

  end
  class HashExpression < ArrayExpression
    def compile context
      to.do
    end
  end
end