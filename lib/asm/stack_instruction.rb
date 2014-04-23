require "asm/instruction"

module Asm
    # ADDRESSING MODE 4
    class StackInstruction < Instruction
      include Asm::InstructionTools

      def initialize(opcode , args)
        super(opcode,args)
        @operand = 0
        @cond = 0b1110
        @inst_class = Asm::Instruction::OPC_STACK
        @s = 0
        @rn = 0
        # downward growing, decrement before memory access
        # official ARM style stack as used by gas
        @write_base = 1
        if (opcode == :push)
          @pre_post_index = 1
          @up_down = 0
          @store_load = 0
        else  #pop
          @pre_post_index = 0
          @up_down = 1
          @store_load = 1
        end
      end
      attr_accessor :cond, :inst_class, :pre_post_index, :up_down,
                    :s, :write_base, :store_load, :rn, :operand
                    
      def assemble(io, as)
        cond = @cond.is_a?(Symbol) ?  COND_CODES[@cond]   : @cond
        rn = 13 # sp
        build_operand args

        #assemble of old
        val = @operand
        val |= (rn <<             16)
        val |= (store_load <<     16+4) #20
        val |= (write_base <<     16+4+ 1) 
        val |= (s <<              16+4+ 1+1) 
        val |= (up_down <<        16+4+ 1+1+1)
        val |= (pre_post_index << 16+4+ 1+1+1+1)#24
        val |= (inst_class <<     16+4+ 1+1+1+1 +2) 
        val |= (cond <<           16+4+ 1+1+1+1 +2+2)
        puts "#{self.inspect}"
        io.write_uint32 val
      end
      
      private 
      # Build representation for source value
      def build_operand(arg)
        if (arg.is_a?(Array))
          @operand = 0
          arg.each do |reg |
            reg = reg_ref(reg)
            @operand |= (1 << reg)
          end
        else
          raise Asm::AssemblyError.new("invalid operand argument  #{arg.inspect}")
        end
      end
      
    end
end
