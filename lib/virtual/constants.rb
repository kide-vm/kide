module Vm
  
  # constants are the stuff that you embedd in the program as numbers or strings. 
  # Another way to think about them is as Operands, they have no seperate "identity"
  # and usually end up embedded in the instructions. ie your basic foo + 4 will encode
  # the 4 in the instruction opcode. The 4 is not accessible anywhere else.
  # When it should be usable in other forms, the constant must become a Value first 
  class Constant < Code
    
  end

  # another abstract "marker" class (so we can check for it)
  # derived classes are Boot/Meta Clas and StringConstant 
  class ObjectConstant < Constant
  end

  class IntegerConstant < Constant
    def initialize int
      @integer = int
    end
    attr_reader :integer
    def value
      @integer
    end
    def to_asm
      @integer.to_s
    end
  end

  # The name really says it all.
  # The only interesting thing is storage.
  # Currently string are stored "inline" , ie in the code segment. 
  # Mainly because that works an i aint no elf expert.
  
  class StringConstant < ObjectConstant
    attr_reader :string
    # currently aligned to 4 (ie padded with 0) and off course 0 at the end
    def initialize str
      str = str.to_s if str.is_a? Symbol
      length = str.length 
      # rounding up to the next 4 (always adding one for zero pad)
      pad =  ((length / 4 ) + 1 ) * 4 - length
      raise "#{pad} #{self}" unless pad >= 1
      @string = str + " " * pad
    end

    def result= value
      class_for(MoveInstruction).new(value , self , :opcode => :mov)
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