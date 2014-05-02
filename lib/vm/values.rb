module Vm
  
  # Values represent the information as it is processed. Different subclasses for different types, 
  # each type with different operations.
  # The oprerations on values is what makes a machine do things.
  # For compilation, values are mopped to the machines registers and the functions (on values) map
  # to machine instructions
  
  # Values are immutable! (that's why they are called values)
  # Operations on values _always_ produce new values (conceptionally)
  
  # Values are a way to reason about (create/validate) instructions. The final executable is mostly 
  # instrucions.
  
  # Word Values are what fits in a register. Derived classes
  # Float, Reference , Integer(s) must fit the same registers
  
  class Value
    def bit_size
      8 * byte_size
    end
    
    def byte_size
      raise "abstract method called #{self.inspect}"
    end
    attr :register
    
    def initialize reg = nil
      @register = nil
    end
  end

  class Word < Value
  end
  
  class Unsigned < Word
    
    def + unsigned
      unless unsigned.is_a? Unsigned
        unsigned = Conversion.new( unsigned , Unsigned )
      end
      UnsignedAdd.new( self  , unsigned )
    end
  end

  class Signed < Word
    def + signed
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
  end

  class Byte < Value
  end

end
