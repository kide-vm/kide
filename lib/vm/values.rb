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

    def initialize value
      @value = value
    end
    attr_reader :value
    
    #naming convention to infer types in kernel functions. Kernel types are basic types, ie see below
    # 
    def self.type name
      parts = name.split("_")
      t = "Basic"
      if parts[1]
        t = parts[1]
      end
      t
    end
    
  end

  class Word < Value
    def load reg
      Machine.instance.word_load self , reg
    end
    def length
      4
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
  
  # The name really says it all.
  # The only interesting thing is storage.
  # Currently string are stored "inline" , ie in the code segment. 
  # Mainly because that works an i aint no elf expert.
  
  class StringLiteral < Value
    
    # currently aligned to 4 (ie padded with 0) and off course 0 at the end
    def initialize(str)
      super(str)
      length = str.length 
      # rounding up to the next 4 (always adding one for zero pad)
      pad =  ((length / 4 ) + 1 ) * 4 - length
      raise "#{pad} #{self}" unless pad >= 1
      @value = str + "\x00" * pad 
    end
    def string
      @value
    end

    def load reg_num
      Machine.instance.string_load self , reg_num
    end

    # the strings length plus padding
    def length
      string.length
    end
    
    # just writing the string
    def assemble(io)
      io << string
    end
  end
end
