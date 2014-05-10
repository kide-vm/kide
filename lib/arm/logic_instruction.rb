require_relative "instruction"
require_relative "logic_helper"

module Arm

  class LogicInstruction < Vm::LogicInstruction
    include Arm::Constants
    include LogicHelper

    def initialize(attributes)
      super(attributes)
      @update_status_flag = 0
      @condition_code = :al
      @opcode = attributes[:opcode]
      @operand = 0

      @rn = nil
      @i = 0      
      @rd = @attributes[:left]
    end
    attr_accessor :i, :rn, :rd
    # Build representation for source value 
    def build
      @rn = @attributes[:right]
      do_build @attributes[:extra]
    end
  end
end