module Arm
  # The arm machine has following instruction classes
  # - Memory
  # - Stack
  # - Logic
  # - Math
  # - Control/Compare
  # - Move
  # - Call  class Instruction
  module Attributed

    attr_reader :attributes
    def opcode
      @attributes[:opcode]
    end
    def set_opcode code
      @attributes[:opcode] = code
    end

    # for the shift handling that makes the arm so unique
    def shift val , by
      raise "Not integer #{val}:#{val.class} #{inspect}" unless val.is_a? ::Integer
      val << by
    end

    def condition_code
      shift(cond_bit_code , 28 )
    end

    def instruction_code
      shift(instuction_class ,   26)
    end

    def byte_length
      4
    end
  end
end

require_relative "constants"
require_relative "instructions/instruction"
require_relative "instructions/call_instruction"
require_relative "instructions/compare_instruction"
require_relative "instructions/logic_instruction"
require_relative "instructions/memory_instruction"
require_relative "instructions/move_instruction"
require_relative "instructions/stack_instruction"
