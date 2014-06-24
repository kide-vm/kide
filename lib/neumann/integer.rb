module Vm
  class Integer < Word
    # needs to be here as Word's constructor is private (to make it abstract)
    def initialize reg
      super
    end

    def less_or_equal block , right
      block.cmp( self ,  right )
      Vm::BranchCondition.new :le
    end
    def greater_or_equal block , right
      block.cmp( self ,  right )
      Vm::BranchCondition.new :ge
    end
    def greater_than block , right
      block.cmp( self ,  right )
      Vm::BranchCondition.new :gt
    end
    def less_than block , right
      block.cmp( self ,  right )
      Vm::BranchCondition.new :lt
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
      Vm::BranchCondition.new :eq
    end

    def is_true? function
      function.cmp( self ,  0 )
      Vm::BranchCondition.new :ne
    end

    def move block , right
      block.mov(  self ,  right )
      self
    end
  end
end