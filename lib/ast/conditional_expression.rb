module Ast
  class ConditionalExpression < Expression
    attr_reader  :cond, :if_true, :if_false
    def initialize cond, if_true, if_false
      @cond, @if_true, @if_false = cond, if_true, if_false
    end
    def == other
      compare other , [:cond, :if_true, :if_false]
    end
  end

  
end