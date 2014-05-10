require_relative "instruction"
require_relative "logic_helper"

module Arm

  class MoveInstruction < Vm::MoveInstruction
    include Arm::Constants
    include LogicHelper

    def initialize(attributes) 
      super(attributes)
      @update_status_flag = 0
      @condition_code = :al
      @opcode = attributes[:opcode]
      @args = [attributes[:left] , attributes[:right] , attributes[:extra]]
      @operand = 0

      @i = 0      
      @rd = @args[0]
      @rn = :r0 # register zero = zero bit pattern
    end
  
    def build
      do_build @args[1]
    end
  end
end