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
        #str / ldr are _seruous instructions. With BIG possibilities no half are implemented
        @i = 0
        @pre_post_index = 0
        @w = 0
        @operand = 0
        if (arg.is_a?(Asm::RegisterArgNode))
          @rn = reg_ref(arg)
  
          if (false ) #argr.op and argr.right.is_a?(Asm::NumLiteralArgNode))
  
            # this if was buggy even before
            # but as mentioned here we'd have to implement the options
            # though a better syntax will have to be found
            val = argr.right.value
            if (val < 0)
              @add_offset = 0
              val *= -1
            else
              @add_offset = 1
            end
            if (val.abs > 4095)
              raise Asm::AssemblyError.new('reference offset too large/small (max 4095)', argr.right)
            end
            @operand = val
          else
            # raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG, arg)
          end
        elsif (arg.is_a?(Asm::LabelRefArgNode) or arg.is_a?(Asm::NumLiteralArgNode))
          @pre_post_index = 1
          @rn = 15 # pc
          @use_addrtable_reloc = true
          @addrtable_reloc_target = arg
        else
          raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG + " " + arg.inspect, arg.inspect)
        end
      end

      def write(io, as, ast_asm, inst)
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
        if (@use_addrtable_reloc)
#          closest_addrtable = Asm::Arm.closest_addrtable(as)
          if (@addrtable_reloc_target.is_a?(Asm::LabelRefArgNode))
            obj = ast_asm.object_for_label(@addrtable_reloc_target.label, inst)
            ref_label = closest_addrtable.add_label(obj)
          elsif (@addrtable_reloc_target.is_a?(Asm::NumLiteralArgNode))
            ref_label = closest_addrtable.add_const(@addrtable_reloc_target.value)
          end
          as.add_relocation io.tell, ref_label, Asm::Arm::R_ARM_PC12,
                            Asm::Arm::Instruction::RelocHandler
        end
        io.write_uint32 val
      end
    end
  end
end