module Register
  class Reference < Word
    # needs to be here as Word's constructor is private (to make it abstract)
    def initialize reg , clazz = nil
      super(reg)
      @clazz = clazz
    end
    attr_accessor :clazz

    def load block , right
      if(right.is_a? IntegerConstant)
        block.mov(  self ,  right )  #move the value
      elsif right.is_a? StringConstant
        block.add( self , right , nil)   #move the address, by "adding" to pc, ie pc relative
        block.mov( Integer.new(self.register.next_reg_use) ,  right.word_length )  #and the length HACK TODO
      elsif right.is_a?(Boot::BootClass) or right.is_a?(Boot::MetaClass)
        block.add( self , right , nil)   #move the address, by "adding" to pc, ie pc relative
      else
        raise "unknown #{right.inspect}" 
      end
      self
    end

    def at_index block , left , right
      block.ldr( self , left , right )
      self
    end

  end
end
