module Virtual
  
  class Constant < ::Virtual::Value
  end
  class TrueValue < Constant
  end
  class FalseValue < Constant
  end
  class NilValue < Constant
  end

  # another abstract "marker" class (so we can check for it)
  # derived classes are Boot/Meta Class and StringConstant 
  class ObjectConstant < Constant
    def type
      Virtual::Reference
    end
    def claszz
      raise "abstract #{self}"
    end
  end

  class IntegerConstant < Constant
    def initialize int
      @integer = int
    end
    attr_reader :integer
    def type
      Virtual::Integer
    end
  end

  # The name really says it all.
  # The only interesting thing is storage.
  # Currently string are stored "inline" , ie in the code segment. 
  # Mainly because that works an i aint no elf expert.
  
  class StringConstant < ObjectConstant
    def initialize str
      @string = str
    end
    attr_reader :string
    def result= value
      class_for(MoveInstruction).new(value , self , :opcode => :mov)
    end
    def clazz
      BootSpace.space.get_or_create_class(:String)
    end
  end
  
end