require_relative '../helper'

module SlotMachine
  class InstructionMock < Instruction
    def initialize
      super("mocking")
    end
  end
end
