require_relative "logic_helper"

module Arm

  class MoveInstruction < Vm::MoveInstruction
    include Arm::Constants
    include LogicHelper

    def initialize(attributes) 
      super(attributes)
      @attributes[:update_status_flag] = 0
      @attributes[:condition_code] = :al
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @i = 0      
      @rd = @attributes[:left]
      @rn = :r0 # register zero = zero bit pattern
    end
  
    def build
      do_build @attributes[:right]
    end
  end
end