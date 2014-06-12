require_relative "code"

module Vm
  
  # Values represent the information as it is processed. Different subclasses for different types, 
  # each type with different operations.
  # The oprerations on values is what makes a machine do things. Operations are captured as 
  # subclasses of Instruction and saved to Blocks
  
  # Values are immutable! (that's why they are called values)
  # Operations on values _always_ produce new values (conceptionally)
  
  # Values are a way to reason about (create/validate) instructions. 
  # In fact a linked lists of values is created by invoking instructions
  # the linked list goes from value to instruction to value, backwards
  
  # Word Values are what fits in a register. Derived classes
  # Float, Reference , Integer(s) must fit the same registers
  
  # just a base class for data. not sure how this will be usefull (may just have read too much llvm)
  class Value 
    def class_for clazz
      RegisterMachine.instance.class_for(clazz)
    end
  end

  # Just a nice way to write branches
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

  # RegisterUSe is _not_ the name for a register, "only" for a certain use of it. 
  # In a way it is like a variable name, a storage location. The location is a register off course, 
  # but which register can be changed, and _all_ instructions sharing the RegisterUse then use that register
  # In other words a simple level of indirection, or change from value to reference sematics.
  class RegisterUse
    attr_accessor :symbol
    def initialize r
      if( r.is_a? Fixnum)
        r = "r#{r}".to_sym
      end
      raise "wrong type for register init #{r}" unless r.is_a? Symbol
      raise "double r #{r}" if r == :rr1
      @symbol = r
    end

    def == other
      return false if other.nil?
      return false if other.class != RegisterUse
      symbol == other.symbol
    end

    #helper method to calculate with register symbols
    def next_reg_use by = 1
      int = @symbol[1,3].to_i
      sym = "r#{int + by}".to_sym
      RegisterUse.new( sym )
    end
  end

  # This is what it is when we don't know what it is. #TODO, better if it were explicitly a different type, not the base
  # Must be promoted to A Word-Value to to anything                       makes is_a chaecking easier
  # remembering that our oo machine is typed, no overloading or stuff
  class Word < Value

    attr_accessor :used_register

    def register_symbol
      @used_register.symbol
    end
    def inspect
      "#{self.class.name} (#{register_symbol})"
    end
    def to_s
      inspect
    end
    def initialize reg
      if reg.is_a? RegisterUse
        @used_register = reg
      else
        @used_register = RegisterUse.new(reg)
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
      RegisterMachine.instance.integer_less_or_equal block , self , right
    end
    def greater_or_equal block , right
      RegisterMachine.instance.integer_greater_or_equal block , self , right
    end
    def greater_than block , right
      RegisterMachine.instance.integer_greater_than block , self , right
    end
    def less_than block , right
      RegisterMachine.instance.integer_less_than block , self , right
    end
#    def == other
#      code = class_for(CompareInstruction).new(self , other , opcode: :cmp)
#    end
#    def + other
#      class_for(LogicInstruction).new(nil , self , other , opcode: :add)
#    end
#    def - other
#      class_for(LogicInstruction).new(nil , self , other , opcode:  :sub )#, update_status: 1 )
#    end
    def at_index block , left , right
      RegisterMachine.instance.integer_at_index block , self , left , right
    end
    def plus block , first , right
      RegisterMachine.instance.integer_plus block , self , first , right
    end
    def minus block , first , right
      RegisterMachine.instance.integer_minus block , self , first , right
    end
    def left_shift block , first , right
      RegisterMachine.instance.integer_left_shift block , self , first , right
    end
    def equals block , right
      RegisterMachine.instance.integer_equals block , self , right
    end
    
    def load block , right
      if(right.is_a? IntegerConstant)
        block.mov(  self ,  right )  #move the value
      elsif right.is_a? StringConstant
        block.add( self , right , nil)   #move the address, by "adding" to pc, ie pc relative
        block.mov( Integer.new(self.used_register.next_reg_use) ,  right.length )  #and the length HACK TODO
      elsif right.is_a?(BootClass) or right.is_a?(MetaClass)
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