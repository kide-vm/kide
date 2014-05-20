require_relative "code"

module Vm
  
  # Values represent the information as it is processed. Different subclasses for different types, 
  # each type with different operations.
  # The oprerations on values is what makes a machine do things.
  # For compilation, values are moved to the machines registers and the methods (on values) map
  #     to machine instructions
  
  # Values are immutable! (that's why they are called values)
  # Operations on values _always_ produce new values (conceptionally)
  
  # Values are a way to reason about (create/validate) instructions. 
  # In fact a linked lists of values is created by invoking instructions
  # the linked list goes from value to instruction to value, backwards
  
  # Word Values are what fits in a register. Derived classes
  # Float, Reference , Integer(s) must fit the same registers
  
  # just a base class for data. not sure how this will be usefull (may just have read too much llvm)
  class Value < Code

    def class_for clazz
      CMachine.instance.class_for(clazz)
    end
    # part of the dsl, ie serves to make code like  value.is a + b     work
    # ie we save the receier as the result into the instruction and pass that back
    def is instruction
      instruction.result = self
      instruction
    end
    def type
      self.class
    end
  end

  # Just a nice way to write branches
  class Bool < Value

  end

  # This is what it is when we don't know what it is.
  # Must be promoted to A Word-Value to to anything
  # remembering that our oo machine is typed, no overloading or stuff
  class Word < Value

    attr_accessor :register

    def inspect
      self.class.name + "(r#{register})"
    end
    def to_s
      inspect
    end
    def initialize reg
      @register = reg
    end
    def length
      4
    end
  end
  
  class Unsigned < Word
    
    def plus block , unsigned
      CMachine.instance.unsigned_plus self , unsigned
    end
  end

  class Integer < Word

    # part of the dsl. 
    # Gets called with either fixnum/IntegerConstant or an Instruction (usually logic, iw add...)
    # For instructions we flip, ie call the assign on the instruction
    # but for constants we have to create instruction first (mov)
    def assign other
      other = Vm::IntegerConstant.new(other) if other.is_a? Fixnum
      if other.is_a? Vm::IntegerConstant
        class_for(MoveInstruction).new( self , other , :opcode => :mov)
      else 
        other.assign(self)
      end
    end

    def less_or_equal block , right
      CMachine.instance.integer_less_or_equal block , self , right
    end

    def + other
      class_for(LogicInstruction).new(nil , self , other , opcode: :add)
    end
    def - other
      class_for(LogicInstruction).new(nil , self , other , opcode:  :sub , update_status: 1 )
    end
    def plus block , first , right
      CMachine.instance.integer_plus block , self , first , right
    end
    def minus block , first , right
      CMachine.instance.integer_minus block , self , first , right
    end
    
    def load block , right
      CMachine.instance.integer_load block , self , right
    end

    def move block , right
      CMachine.instance.integer_move block , self , right
    end

  end
end
require_relative "constants"