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
      self.class.name + ":reg:#{register}:"
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

    def less_or_equal block , right
      CMachine.instance.integer_less_or_equal block , self , right
    end

    def plus block , right
      CMachine.instance.integer_plus block , self , right
    end
    
    def load block , right
      CMachine.instance.integer_load block , self , right
    end
  end
end
require_relative "constants"