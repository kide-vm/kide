module Virtual
  
  class Constant < ::Virtual::Value
  end
  class TrueValue < Constant
    def attributes ; [] ; end
  end
  class FalseValue < Constant
    def attributes ; [] ; end
  end
  class NilValue < Constant
    def attributes ; [] ; end
  end

  # another abstract "marker" class (so we can check for it)
  # derived classes are Boot/Meta Class and StringConstant 
  class ObjectConstant < Constant
  end

  class IntegerConstant < Constant
    def initialize int
      @integer = int
    end
    attr_reader :integer
    def attributes
      [:integer]
    end
    def inspect
      self.class.name + ".new(#{@integer})"
    end
    def type
      Virtual::Integer
    end
  end

  # The name really says it all.
  # The only interesting thing is storage.
  # Currently string are stored "inline" , ie in the code segment. 
  # Mainly because that works an i aint no elf expert.
  
  class StringConstant < ObjectConstant
    attr_reader :string
    def attributes 
      [:string]
    end
    def initialize str
      @string = str
    end

    def result= value
      class_for(MoveInstruction).new(value , self , :opcode => :mov)
    end
    def inspect
      self.class.name + ".new('#{@string}')"
    end
  end
  
end