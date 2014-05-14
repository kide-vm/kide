require_relative "logic_helper"

module Arm

  class LogicInstruction < Vm::LogicInstruction
    include Arm::Constants
    include LogicHelper

    def initialize(attributes)
      super(attributes)
      @attributes[:update_status_flag] = 0 if @attributes[:update_status_flag] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
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