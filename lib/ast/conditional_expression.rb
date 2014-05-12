module Ast
  class ConditionalExpression < Expression
    attr_reader  :cond, :if_true, :if_false
    def initialize cond, if_true, if_false
      @cond, @if_true, @if_false = cond, if_true, if_false
    end
    def inspect
      self.class.name + ".new(" + cond.inspect + ", "+ 
        if_true.inspect +  ","  + if_false.inspect + " )"  
    end
    def attributes
      [:cond, :if_true, :if_false]
    end
  end
end