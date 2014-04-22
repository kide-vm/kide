require "asm/nodes"

module Asm
  module Arm
    # ADDRESSING MODE 2
    # Implemented: immediate offset with offset=0
    class MemoryAccessBuilder
      include Asm::Arm::InstructionTools

      def initialize(inst_class, byte_access, load_store)
        @cond = 0b1110
        @inst_class = 0
        @i = 0 #I flag (third bit)
        @pre_post_index = 0 #P flag
        @add_offset = 0 #U flag
        @byte_access = 0 #B flag
        @w = 0 #W flag
        @load_store = 0 #L flag
        @rn = 0
        @rd = 0
        @operand = 0
        @inst_class = inst_class
        @byte_access = byte_access
        @load_store = load_store
      end
      attr_accessor :cond, :inst_class, :i, :pre_post_index, :add_offset,
                    :byte_access, :w, :load_store, :rn, :rd, :operand

      # Build representation for target address
      def build_operand(arg)
        #str / ldr are _serious instructions. With BIG possibilities not half are implemented
        @i = 0
        @pre_post_index = 0
        @w = 0
        @operand = 0
        if (arg.is_a?(Asm::RegisterNode))
          @rn = reg_ref(arg)
          if(arg.offset != 0) 
            @operand = arg.offset
            if (@operand < 0)
              @add_offset = 0
              #TODO test/check/understand
              @operand *= -1
            else
              @add_offset = 1
            end
            if (@operand.abs > 4095)
              raise Asm::AssemblyError.new('reference offset too large/small (max 4095)', argr.right)
            end
          end
        elsif (arg.is_a?(Asm::LabelRefNode) or arg.is_a?(Asm::NumLiteralNode))
          @pre_post_index = 1
          @rn = 15 # pc
          @use_addrtable_reloc = true
          @addrtable_reloc_target = arg
        else
          raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG + " " + arg.inspect, arg.inspect)
        end
      end

      def assemble(io, as, inst)
        #not sure about these 2 constants. They produce the correct output for str r0 , r1
        # but i can't help thinking that that is because they are not used in that instruction and
        # so it doesn't matter. Will see
        @add_offset = 1
        @pre_post_index = 1
        val = operand | (rd << 12 ) | (rn << 12 + 4) |
              (load_store << 12+4+4) | (w << 12+4+4+1) |
              (byte_access << 12+4+4+1+1) | (add_offset << 12+4+4+1+1+1) |
              (pre_post_index << 12+4+4+1+1+1+1) | (i << 12+4+4+1+1+1+1+1) |
              (inst_class << 12+4+4+1+1+1+1+1+1) | (cond << 12+4+4+1+1+1+1+1+1+2)
        # move towards simpler model
        if (@use_addrtable_reloc)
#          closest_addrtable = Asm::Arm.closest_addrtable(as)
          if (@addrtable_reloc_target.is_a?(Asm::LabelRefNode))
            obj = generator.object_for_label(@addrtable_reloc_target.label, inst)
#            ref_label = closest_addrtable.add_label(obj)
          elsif (@addrtable_reloc_target.is_a?(Asm::NumLiteralNode))
#            ref_label = closest_addrtable.add_const(@addrtable_reloc_target.value)
          end
          as.add_relocation io.tell, ref_label, Asm::Arm::R_ARM_PC12,
                            Asm::Arm::Instruction::RelocHandler
        end
        io.write_uint32 val
      end
    end
  end
end