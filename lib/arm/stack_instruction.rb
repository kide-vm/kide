require "vm/instruction"
require_relative "constants"

module Arm
  # ADDRESSING MODE 4
  class StackInstruction < Vm::StackInstruction
    include Arm::Constants

    # arm intrucioons are pretty sensible, and always 4 bytes (thumb not supported)
    def length
      4
    end

    def initialize(first , attributes)
      super(first , attributes) 
      @attributes[:update_status] = 0 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @attributes[:update_status]= 0
      @rn = :r0 # register zero = zero bit pattern
      # downward growing, decrement before memory access
      # official ARM style stack as used by gas
    end
                  
    def assemble(io)
      build
      write_base = 1
      if (opcode == :push)
        pre_post_index = 1
        up_down = 0
        is_pop = 0
      else  #pop
        pre_post_index = 0
        up_down = 1
        is_pop = 1
      end
      instuction_class = 0b10 # OPC_STACK
      cond = @attributes[:condition_code].is_a?(Symbol) ?  COND_CODES[@attributes[:condition_code]]   : @attributes[:condition_code]
      @rn = :sp # sp register
      #assemble of old
      val = @operand
      val |= (reg_code(@rn) <<             16)
      val |= (is_pop <<              16+4) #20
      val |= (write_base <<          16+4+ 1) 
      val |= (@attributes[:update_status] <<  16+4+ 1+1) 
      val |= (up_down <<             16+4+ 1+1+1)
      val |= (pre_post_index <<      16+4+ 1+1+1+1)#24
      val |= (instuction_class <<    16+4+ 1+1+1+1 +2) 
      val |= (cond <<                16+4+ 1+1+1+1 +2+2)
      io.write_uint32 val
    end
    
    private 
    # Build representation for source value
    def build
      regs = @first
      if (regs.is_a?(Array))
        @operand = 0
        regs.each_with_index do |reg , index|
          raise "nil register in push, index #{index}" if reg == nil
          @operand |= (1 << reg_code(reg))
        end
      else
        raise "invalid operand argument  #{regs.inspect} #{inspect}"
      end
    end
  end
end
