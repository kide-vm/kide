module Arm
  # The arm machine has following instruction classes
  # - Memory
  # - Stack
  # - Logic
  # - Math
  # - Control/Compare
  # - Move
  # - Call  class Instruction
  class Instruction
    def initialize  options
      @attributes = options
    end
    attr_reader :attributes
    def opcode
      @attributes[:opcode]
    end
  end
end

require_relative "constants"
require_relative "instructions/call_instruction"
require_relative "instructions/compare_instruction"
require_relative "instructions/logic_instruction"
require_relative "instructions/memory_instruction"
require_relative "instructions/move_instruction"
require_relative "instructions/stack_instruction"
