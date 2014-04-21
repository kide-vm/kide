module Asm
  module Arm
    # ADDRESSING MODE 4
    class StackBuilder
      include Asm::Arm::InstructionTools

      def initialize(pre_post, up_down, write, store_load)
        @cond = 0b1110
        @inst_class = Asm::Arm::Instruction::OPC_STACK
        @pre_post_index = 0
        @up_down = 0
        @s = 0
        @write_base = 0
        @store_load = 0
        @rn = 0
        @operand = 0
        @pre_post_index = pre_post
        @up_down = up_down
        @write_base = write
        @store_load = store_load
      end
      attr_accessor :cond, :inst_class, :pre_post_index, :up_down,
                    :s, :write_base, :store_load, :rn, :operand

      # Build representation for source value
      def build_operand(arg)
        if (arg.is_a?(Array))
          @operand = 0
          arg.each do |sym , reg |
            #allow an array of reg (strings), or the [:reg , name] produced by the instruction functions
            reg = sym == :reg ? reg : sym
            reg = reg_ref(reg)
            @operand |= (1 << reg)
          end
        else
          raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG + " " + arg.inspect , arg)
        end
      end

      def assemble(io, as)
        val = operand | (rn << 16) | (store_load << 16+4) | 
              (write_base << 16+4+1) | (s << 16+4+1+1) | (up_down << 16+4+1+1+1) |
              (pre_post_index << 16+4+1+1+1+1) | (inst_class << 16+4+1+1+1+1+2) |
              (cond << 16+4+1+1+1+1+2+2)
        io.write_uint32 val
      end
    end
  end
end
