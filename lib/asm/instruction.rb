require_relative "assembly_error"
require_relative "arm_machine"

module Asm

  class Code ; end
  
  # Not surprisingly represents an cpu instruction. 
  # This is an abstract base class, with derived classes 
  # Logic / Move / Compare / Stack / Memory (see there)
  # 
  # Opcode is a (<= three) letter accronym (same as in assembly code). Though in arm, suffixes can
  # make the opcode longer, we chop those off in the constructor
  # Argurments are registers or labels or string/num Literals
  
  class Instruction < Code
    include ArmMachine

    COND_POSTFIXES = Regexp.union( COND_CODES.keys.collect{|k|k.to_s} ).source

    def initialize(opcode , condition_code , update_status , args)
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
end