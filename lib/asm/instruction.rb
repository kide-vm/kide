require_relative "label"
require_relative "assembly_error"
require_relative "instruction_tools"

module Asm

  # Not surprisingly represents an cpu instruction. 
  # This is an abstract base class, with derived classes 
  # Logic / Move / Compare / Stack / Memory (see there)
  # 
  # Opcode is a (<= three) letter accronym (same as in assembly code). Though in arm, suffixes can
  # make the opcode longer, we chop those off in the constructor
  # Argurments are registers or labels or string/num Literals
  
  class Instruction < Code
    include InstructionTools

    COND_POSTFIXES = Regexp.union( COND_CODES.keys.collect{|k|k.to_s} ).source

    def initialize(opcode , args)
      opcode = opcode.to_s.downcase
      @cond = :al
      if (opcode =~ /(#{COND_POSTFIXES})$/)
        @cond = $1.to_sym
        opcode = opcode[0..-3]
      end unless opcode == 'teq'
      if (opcode =~ /s$/)
        @update_status_flag= 1
        opcode = opcode[0..-2]
      else
        @update_status_flag= 0
      end
      @opcode = opcode.downcase.to_sym
      @args = args
      @operand = 0
    end
    attr_reader :opcode, :args , :position , :cond , :operand , :update_status_flag

    def affect_status
      @s
    end
    
    # arm intrucioons are pretty sensible, and always 4 bytes (thumb not supported)
    def length
      4
    end
  end
end