module Asm
  module Arm
    # ADDRESSING MODE 1
    # Complete!
    class NormalBuilder
      include Asm::Arm::InstructionTools

      def initialize(inst_class, opcode, s)
        @cond = 0b1110
        @inst_class = 0
        @i = 0
        @opcode = 0
        @s = 0
        @rn = 0
        @rd = 0
        @operand = 0
        @inst_class = inst_class
        @opcode = opcode
        @s = s
      end
      attr_accessor :cond, :inst_class, :i, :opcode, :s,
                    :rn, :rd, :operand

      def calculate_u8_with_rr(arg)
        parts = arg.value.to_s(2).rjust(32,'0').scan(/^(0*)(.+?)0*$/).flatten
        pre_zeros = parts[0].length
        imm_len = parts[1].length
        if ((pre_zeros+imm_len) % 2 == 1)
          u8_imm = (parts[1]+'0').to_i(2)
          imm_len += 1
        else
          u8_imm = parts[1].to_i(2)
        end
        if (u8_imm.fits_u8?)
          # can do!
          rot_imm = (pre_zeros+imm_len) / 2
          if (rot_imm > 15)
            return nil
          end
          return u8_imm | (rot_imm << 8)
        else
          return nil
        end
      end

      # Build representation for source value
      def build_operand(arg)
        if (arg.is_a?(Asm::NumLiteralNode))
          if (arg.value.fits_u8?)
            # no shifting needed
            @operand = arg.value
            @i = 1
          elsif (op_with_rot = calculate_u8_with_rr(arg))
            @operand = op_with_rot
            @i = 1
          else
            raise Asm::AssemblyError.new(Asm::ERRSTR_NUMERIC_TOO_LARGE, arg)
          end
        elsif (arg.is_a?(Asm::RegisterNode))
          @operand = reg_ref(arg)
          @i = 0
        elsif (arg.is_a?(Asm::ShiftNode))
          rm_ref = reg_ref(arg.argument)
          @i = 0
          shift_op = {'lsl' => 0b000, 'lsr' => 0b010, 'asr' => 0b100,
                      'ror' => 0b110, 'rrx' => 0b110}[arg.type]
          if (arg.type == 'ror' and arg.value.nil?)
            # ror #0 == rrx
            raise Asm::AssemblyError.new('cannot rotate by zero', arg)
          end
      
          arg1 = arg.value
          if (arg1.is_a?(Asm::NumLiteralNode))
            if (arg1.value >= 32)
              raise Asm::AssemblyError.new('cannot shift by more than 31', arg1)
            end
            shift_imm = arg1.value
          elsif (arg1.is_a?(Asm::RegisterNode))
            shift_op |= 0x1;
            shift_imm = reg_ref(arg1) << 1
          elsif (arg.type == 'rrx')
            shift_imm = 0
          end
      
          @operand = rm_ref | (shift_op << 4) | (shift_imm << 4+3)
        else
          raise Asm::AssemblyError.new(Asm::ERRSTR_INVALID_ARG + " " + arg.inspect, arg)
        end
      end

      def assemble(io, as)
        val = operand | (rd << 12) | (rn << 12+4) |
              (s << 12+4+4) | (opcode << 12+4+4+1) |
              (i << 12+4+4+1+4) | (inst_class << 12+4+4+1+4+1) |
              (cond << 12+4+4+1+4+1+2)
        io.write_uint32 val
      end
    end

  end
end