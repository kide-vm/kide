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
    attr_accessor :register
    def initialize r
      @register = r
    end
  end

  # This is what it is when we don't know what it is. #TODO, better if it were explicitly a different type, not the base
  # Must be promoted to A Word-Value to to anything                       makes is_a chaecking easier
  # remembering that our oo machine is typed, no overloading or stuff
  class Word < Value

    attr_accessor :used_register

    def register
      @used_register.register
    end

    def inspect
      self.class.name + "(r#{used_register.register})"
    end
    def to_s
      inspect
    end
    def initialize reg
      if reg.is_a? Fixnum
        @used_register = RegisterUse.new(reg)
      else
        @used_register = reg
      end
      raise inspect if reg == nil
    end
    def length
      4
    end
  end
  
  class Unsigned < Word
    
    def plus block , unsigned
      RegisterMachine.instance.unsigned_plus self , unsigned
    end
  end

  class Integer < Word

    # part of the dsl. 
    # Gets called with either fixnum/IntegerConstant or an Instruction (usually logic, iw add...)
    # For instructions we flip, ie call the assign on the instruction
    # but for constants we have to create instruction first (mov)
    def assign other
      other = Vm::IntegerConstant.new(other) if other.is_a? Fixnum
      if other.is_a?(Vm::IntegerConstant) or other.is_a?(Vm::Integer)
        class_for(MoveInstruction).new( self , other , :opcode => :mov)
      elsif other.is_a?(Vm::StringConstant) # pc relative addressing
        class_for(LogicInstruction).new(self , other , nil , opcode: :add)
      else
        other.assign(self)
      end
    end

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
    def equals block , right
      RegisterMachine.instance.integer_equals block , self , right
    end
    def == other
      code = class_for(CompareInstruction).new(self , other , opcode: :cmp)
    end
    def + other
      class_for(LogicInstruction).new(nil , self , other , opcode: :add)
    end
    def - other
      class_for(LogicInstruction).new(nil , self , other , opcode:  :sub )#, update_status: 1 )
    end
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
    
    def load block , right
      if(right.is_a? IntegerConstant)
        block.mov(  self ,  right )  #move the value
      elsif right.is_a? StringConstant
        block.add( self , right , nil)   #move the address, by "adding" to pc, ie pc relative
        block.mov( Integer.new(register+1) ,  right.length )  #and the length HACK TODO
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