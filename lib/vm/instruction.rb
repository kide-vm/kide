
module Vm
  # Instruction represent the actions that affect change on Values
  # In an OO way of thinking the Value is data, Instruction the functionality

  # But to allow flexibility, the value api bounces back to the machine api, so machines instantiate
  # intructions.
  
  # When Instructions are instantiated the create a linked list of Values and Instructions.
  # So Value links to Instruction and Instruction links to Value
  # Also, because the idea of what one instruction does, does not always map one to one to real machine
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
  class Code ; end

  class Instruction < Code
    
  end
  
  class StackInstruction < Instruction
  end
  class MemoryInstruction < Instruction
  end
  class LogicInstruction < Instruction
  end
  class MathInstruction < Instruction
  end
  class CompareInstruction < Instruction
  end
  class MoveInstruction < Instruction
  end
  class CallInstruction < Instruction
  end
end
