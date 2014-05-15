require_relative "logic_helper"

module Arm

  class MoveInstruction < Vm::MoveInstruction
    include Arm::Constants
    include LogicHelper

    def initialize(left , attributes) 
      super(left , attributes)
      @attributes[:update_status_flag] = 0 if @attributes[:update_status_flag] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @i = 0      
      @rd = @left
      @rn = :r0 # register zero = zero bit pattern
    end
  
    def build
      do_build @attributes[:right]
    end
  end
end