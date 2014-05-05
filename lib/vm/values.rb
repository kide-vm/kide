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
  
  class Value
    def bit_size
      8 * byte_size
    end
    
    def byte_size
      raise "abstract method called #{self.inspect}"
    end
    
    # since we convert ast to values in conversion, value itself is responsible for compiling itself
    # Compile must return a value, usually used in the next level up
    def compile(context)
      raise "abstract method called #{self.inspect}"
    end
  end

  class Word < Value
    def load reg
      Machine.instance.word_load self , reg
    end
    def compile context
      #nothing to do here
    end
  end
  
  class Unsigned < Word
    
    def plus unsigned
      Machine.instance.unsigned_plus self , unsigned
    end
  end

  class Signed < Word
    def plus signed
      Machine.instance.signed_plus self , signed
    end
  end
  
  class Float < Word
  end
  
  class Reference < Word
  end
  class StringValue < Value
    def initialize string
      @string = string
    end
    def at pos
      @pos = pos
    end
    def length
      @string.length + 3
    end
    def compile context
      #nothing to do here
    end
    attr_reader :string
  end
  
  class MemoryReference < Reference
  end

  class ObjectReference < Reference
    def initialize obj
      @object = obj
    end
    attr_reader :object
    
    def compile context
      if object.is_a? StringValue
        context.program.add_object object
      else
        #TODO define object layout more generally and let objects lay themselves out
        # as it is the program does this (in the objectwriter/stringtable)
        un.done
      end
    end
  end

end
