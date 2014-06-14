module Vm
  class Integer < Word
    # needs to be here as Word's constructor is private (to make it abstract)
    def initilize reg
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
    def at_index block , left , right
      block.ldr( self , left , right )
      self
    end
    def plus block , first , right
      block.add( self , left ,  right )
      self
    end
    def minus block , left , right
      block.sub( self ,  left ,  right )
      self
    end
    def left_shift block , first , right
      block.mov( self ,  left , shift_lsr: right )
      self
    end
    def equals block , right
      block.cmp( self ,  right )
      Vm::BranchCondition.new :eq
    end
    
    def load block , right
      if(right.is_a? IntegerConstant)
        block.mov(  self ,  right )  #move the value
      elsif right.is_a? StringConstant
        block.add( self , right , nil)   #move the address, by "adding" to pc, ie pc relative
        block.mov( Integer.new(self.register.next_reg_use) ,  right.length )  #and the length HACK TODO
      elsif right.is_a?(Boot::BootClass) or right.is_a?(Boot::MetaClass)
        block.add( self , right , nil)   #move the address, by "adding" to pc, ie pc relative
      else
        raise "unknown #{right.inspect}" 
      end
      self
    end

    def move block , right
      block.mov(  self ,  right )
      self
    end
  end
end