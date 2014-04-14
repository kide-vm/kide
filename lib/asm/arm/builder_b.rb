require "asm/parser"

module Asm
  module Arm
    # ADDRESSING MODE 2
    # Implemented: immediate offset with offset=0
    class BuilderB
      include Asm::Arm::InstructionTools

      def initialize
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
      end
      attr_accessor :cond, :inst_class, :i, :pre_post_index, :add_offset,
                    :byte_access, :w, :load_store, :rn, :rd, :operand

      def self.make(inst_class, byte_access, load_store)
        a = new
        a.inst_class = inst_class
        a.byte_access = byte_access
        a.load_store = load_store
        a
      end

      class MathReferenceArgNode < Asm::Parser::ReferenceArgNode
        attr_accessor :op, :right
      end
      def simplify_reference(arg)
        node = MathReferenceArgNode.new

        if (arg.is_a?(Asm::Parser::MathNode))
          node.argument = arg.left
          node.op = arg.op
          node.right = arg.right
        else
          node.argument = arg
        end

        node
      end

      # Build representation for target address
      def build_operand(arg1)
        if (arg1.is_a?(Asm::Parser::ReferenceArgNode))
          argr = simplify_reference(arg1.argument)
          arg = argr.argument
          if (arg.is_a?(Asm::Parser::RegisterArgNode))
            @i = 0
            @pre_post_index = 1
            @w = 0
            @rn = reg_ref(arg)
            @operand = 0
    
            if (argr.op and argr.right.is_a?(Asm::Parser::NumLiteralArgNode))
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
            elsif (argr.op)
              raise Asm::AssemblyError.new('reference offset must be an integer literal', argr.right)
            end
          else
            raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG, arg)
          end
        elsif (arg1.is_a?(Asm::Parser::LabelEquivAddrArgNode) or arg1.is_a?(Asm::Parser::NumEquivAddrArgNode))
          @i = 0
          @pre_post_index = 1
          @w = 0
          @rn = 15 # pc
          @operand = 0
          @use_addrtable_reloc = true
          @addrtable_reloc_target = arg1
        else
          raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG, arg1)
        end
      end

      def write(io, as, ast_asm, inst)
        val = operand | (rd << 12) | (rn << 12+4) |
              (load_store << 12+4+4) | (w << 12+4+4+1) |
              (byte_access << 12+4+4+1+1) | (add_offset << 12+4+4+1+1+1) |
              (pre_post_index << 12+4+4+1+1+1+1) | (i << 12+4+4+1+1+1+1+1) |
              (inst_class << 12+4+4+1+1+1+1+1+1) | (cond << 12+4+4+1+1+1+1+1+1+2)
        if (@use_addrtable_reloc)
          closest_addrtable = Asm::Arm.closest_addrtable(as)
          if (@addrtable_reloc_target.is_a?(Asm::Parser::LabelEquivAddrArgNode))
            obj = ast_asm.object_for_label(@addrtable_reloc_target.label, inst)
            ref_label = closest_addrtable.add_label(obj)
          elsif (@addrtable_reloc_target.is_a?(Asm::Parser::NumEquivAddrArgNode))
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