require_relative '../helper'

module Mom
  class InstructionMock < Instruction
    def initialize
      super("mocking")
    end
  end
end
