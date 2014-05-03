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
    
  end

  class Word < Value
    def load
      Machine.instance.word_load self
    end
  end
  
  class Unsigned < Word
    
    def plus unsigned
      unless unsigned.is_a? Unsigned
        unsigned = Conversion.new( unsigned , Unsigned )
      end
      UnsignedAdd.new( self  , unsigned )
    end
  end

  class Signed < Word
    def plus signed
      unless signed.is_a? Signed
        signed = Conversion.new( signed , Signed )
      end
      SignedAdd.new( self  , signed )
    end
  end
  
  class Float < Word
  end
  
  class Reference < Word
  end
  
  class MemoryReference < Reference
  end

  class ObjectReference < Reference
    def initialize obj
      @object = obj
    end
    attr_reader :object
    
    def compile context
      if object.is_a? String
        context.program.add_object object
      else
        #TODO define object layout more generally and let objects lay themselves out
        # as it is the program does this (in the objectwriter/stringtable)
        un.done
      end
    end
  end

end

require_relative "conversion"