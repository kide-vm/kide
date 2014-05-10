require_relative "instruction"
require_relative "logic_helper"

module Arm
  class CompareInstruction < Vm::CompareInstruction
    include Arm::Constants
    include LogicHelper

    def initialize(attributes)
      super(attributes) 
      @condition_code = :al
      @opcode = attributes[:opcode]
      @args = [attributes[:left] , attributes[:right] , attributes[:extra]]
      @operand = 0
      @i = 0      
      @update_status_flag = 1
      @rn = @args[0]
      @rd = :r0
    end
    def build 
      do_build @args[1]
    end
  end
end