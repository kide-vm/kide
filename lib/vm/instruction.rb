require_relative "code"
require "support/hash_attributes"
module Vm

  # Because the idea of what one instruction does, does not always map one to one to real machine
  # instructions, and instruction may link to another instruction thus creating an arbitrary list
  # to get the job (the original instruciton) done
  
  # Admittately it would be simpler just to create the (abstract) instructions and let the machine 
  # encode them into what-ever is neccessary, but this approach leaves more possibility to 
  # optimize the actual instruction stream (not just the crystal instruction stream). Makes sense?
  
  # We have basic classes (literally) of instructions
  # - Memory
  # - Stack
  # - Logic
  # - Math
  # - Control/Compare
  # - Move
  # - Call
  
  # Instruction derives from Code, for the assembly api
  
  class Instruction < Code
    # Make hash attributes to object attributes
    include Support::HashAttributes
    
    def initialize  options
      @attributes = options
    end
  end
  
  class StackInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
    end
  end
  class MemoryInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
    end
  end
  class LogicInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
    end
  end
  class MathInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
    end
  end
  class CompareInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
    end
  end
  class MoveInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
    end
  end
  class CallInstruction < Instruction
    def initialize first , options
      @first = first
      super(options)
      opcode = @attributes[:opcode].to_s
      if opcode.length == 3 and opcode[0] == "b"
        @attributes[:condition_code] = opcode[1,2].to_sym
        @attributes[:opcode] = :b
      end
      if opcode.length == 6 and opcode[0] == "c"
        @attributes[:condition_code] = opcode[4,2].to_sym
        @attributes[:opcode] = :call
      end
    end
  end
end
