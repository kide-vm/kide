require "vm/instruction"
require_relative "constants"

class Saved

    def initializ(opcode , condition_code , update_status , args)
      @update_status_flag = update_status
      @condition_code = condition_code.to_sym
      @opcode = opcode
      @args = args
      @operand = 0
    end
    
    attr_reader :opcode, :args 
    # Many arm instructions may be conditional, where the default condition is always (al)
    # ArmMachine::COND_CODES names them, and this attribute reflects it
    attr_reader :condition_code
    attr_reader :operand

    # Logic instructions may be executed with or without affecting the status register
    # Only when an instruction affects the status is a subsequent compare instruction effective
    # But to make the conditional execution (see cond) work for more than one instruction, one needs to
    # be able to execute without changing the status 
    attr_reader :update_status_flag
    
    # arm intrucioons are pretty sensible, and always 4 bytes (thumb not supported)
    def length
      4
    end
  end
