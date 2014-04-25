require "asm/assembly_error"
require "asm/instruction_tools"
require "asm/label"

module Asm

  class Instruction
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

    def at position 
      @position = position
    end
    
    def length
      4
    end
    
    def assemble(io)
      raise "Abstract class, should not be called/instantiated #{self.inspect}"
    end
  end
end