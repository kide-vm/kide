require_relative "code"
require_relative "register_reference"

module Vm
  
  # Values represent the information as it is processed. Different subclasses for different types, 
  # each type with different operations.
  # The oprerations on values is what makes a machine do things. Operations are captured as 
  # subclasses of Instruction and saved to Blocks
  
  # Values are a way to reason about (create/validate) instructions. 
  
  # Word Values are what fits in a register. Derived classes
  # Float, Reference , Integer(s) must fit the same registers
  
  # just a base class for data. not sure how this will be usefull (may just have read too much llvm)
  class Value 
    def class_for clazz
      RegisterMachine.instance.class_for(clazz)
    end
  end

  # Just a nice way to write branches
  # Comparisons produce them, and branches take them as argument.
  class BranchCondition < Value

    def initialize operator
      @operator = operator
    end
    attr_accessor :operator
    #needed to check the opposite, ie not true
    def not_operator
      case @operator
      when :le
        :gt
      when :gt
        :le
      when :lt
        :ge
      when :eq
        :ne
      else
        raise "no implemented #{@operator}"
      end
    end
  end

  # This is what it is when we don't know what it is. #TODO, better if it were explicitly a different type, not the base
  # Must be promoted to A Word-Value to to anything                       makes is_a chaecking easier
  # remembering that our oo machine is typed, no overloading or stuff
  class Word < Value

    attr_accessor :register

    def register_symbol
      @register.symbol
    end
    def inspect
      "#{self.class.name} (#{register_symbol})"
    end
    def to_s
      inspect
    end
    def initialize reg
      if reg.is_a? RegisterReference
        @register = reg
      else
        @register = RegisterReference.new(reg)
      end
    end
    def length
      4
    end
    # aka to string
    def to_asm
      "#{register_symbol}"
    end
  end
  
  class Unsigned < Word
    
    def plus block , unsigned
      RegisterMachine.instance.unsigned_plus self , unsigned
    end
  end

  class Integer < Word

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
require_relative "constants"