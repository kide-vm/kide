module Ast
  class FunctionExpression < Expression
    attr_reader  :name, :params, :block
    def initialize name, params, block
      @name, @params, @block = name, params, block
    end
    def == other
      compare other , [:name, :params, :block]
    end
  end
end