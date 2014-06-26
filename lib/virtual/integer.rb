module Vm
  class Integer

    def less_or_equal block , right
      block.cmp( self ,  right )
      Virtual::BranchCondition.new :le
    end
    def greater_or_equal block , right
      block.cmp( self ,  right )
      Virtual::BranchCondition.new :ge
    end
    def greater_than block , right
      block.cmp( self ,  right )
      Virtual::BranchCondition.new :gt
    end
    def less_than block , right
      block.cmp( self ,  right )
      Virtual::BranchCondition.new :lt
    end
    def plus block , first , right
      block.add( self , left ,  right )
      self
    end
    def minus block , left , right
      block.sub( self ,  left ,  right )
      self
    end
    def left_shift block , left , right
      block.mov( self ,  left , shift_lsr: right )
      self
    end
    def equals block , right
      block.cmp( self ,  right )
      Virtual::BranchCondition.new :eq
    end

    def is_true? function
      function.cmp( self ,  0 )
      Virtual::BranchCondition.new :ne
    end

    def move block , right
      block.mov(  self ,  right )
      self
    end
  end
end