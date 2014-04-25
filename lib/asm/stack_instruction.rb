require "asm/instruction"

module Asm
  # ADDRESSING MODE 4
  class StackInstruction < Instruction
    include Asm::InstructionTools

    def initialize(opcode , args)
      super(opcode,args)
      @update_status_flag= 0
      @rn = reg "r0" # register zero = zero bit pattern
      # downward growing, decrement before memory access
      # official ARM style stack as used by gas
      @write_base = 1
      if (opcode == :push)
        @pre_post_index = 1
        @up_down = 0
        @is_pop = 0
      else  #pop
        @pre_post_index = 0
        @up_down = 1
        @is_pop = 1
      end
    end
    attr_accessor :pre_post_index, :up_down,
                  :update_status_flag, :write_base, :is_pop, :rn
                  
    def assemble(io)
      build
      instuction_class = 0b10 # OPC_STACK
      cond = @cond.is_a?(Symbol) ?  COND_CODES[@cond]   : @cond
      rn = reg "sp" # sp register
      #assemble of old
      val = operand
      val |= (rn.bits <<             16)
      val |= (is_pop <<              16+4) #20
      val |= (write_base <<          16+4+ 1) 
      val |= (update_status_flag <<  16+4+ 1+1) 
      val |= (up_down <<             16+4+ 1+1+1)
      val |= (pre_post_index <<      16+4+ 1+1+1+1)#24
      val |= (instuction_class <<    16+4+ 1+1+1+1 +2) 
      val |= (cond <<                16+4+ 1+1+1+1 +2+2)
      io.write_uint32 val
    end
    
    private 
    # Build representation for source value
    def build
      if (args.is_a?(Array))
        @operand = 0
        args.each do |reg |
          @operand |= (1 << reg.bits)
        end
      else
        raise Asm::AssemblyError.new("invalid operand argument  #{args.inspect}")
      end
    end
  end
end
