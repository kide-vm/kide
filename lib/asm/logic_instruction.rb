module Asm
  # ADDRESSING MODE 1 
  # Logic ,Maths, Move and compare instructions (last three below)
  
  class LogicInstruction < Instruction
    include Asm::InstructionTools

    def initialize( opcode , args)
      super(opcode , args)
      @rn = nil
      @i = 0
      @rd = args[0]
    end
    attr_accessor :i, :rn, :rd

    # Build representation for source value 
    def build
      @rn = args[1]
      do_build args[2] 
    end
    
    #(stays in subclases, while build is overriden to provide different arguments)
    def do_build(arg)
      if arg.is_a?(Asm::StringLiteral)
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie oc pointing to fetch and not execute)
        arg = Asm::NumLiteral.new( arg.position - self.position - 8 )
      end
      if (arg.is_a?(Asm::NumLiteral))
        if (arg.value.fits_u8?)
          # no shifting needed
          @operand = arg.value
          @i = 1
        elsif (op_with_rot = calculate_u8_with_rr(arg))
          @operand = op_with_rot
          @i = 1
        else
          raise Asm::AssemblyError.new("cannot fit numeric literal argument in operand #{arg}")
        end
      elsif (arg.is_a?(Asm::Register))
        @operand = arg
        @i = 0
      elsif (arg.is_a?(Asm::Shift))
        rm_ref = arg.argument
        @i = 0
        shift_op = {'lsl' => 0b000, 'lsr' => 0b010, 'asr' => 0b100,
                    'ror' => 0b110, 'rrx' => 0b110}[arg.type]
        if (arg.type == 'ror' and arg.value.nil?)
          # ror #0 == rrx
          raise Asm::AssemblyError.new('cannot rotate by zero', arg)
        end
    
        arg1 = arg.value
        if (arg1.is_a?(Asm::NumLiteral))
          if (arg1.value >= 32)
            raise Asm::AssemblyError.new('cannot shift by more than 31', arg1)
          end
          shift_imm = arg1.value
        elsif (arg1.is_a?(Asm::Register))
          shift_op val |= 0x1;
          shift_imm = arg1.number << 1
        elsif (arg.type == 'rrx')
          shift_imm = 0
        end
    
        @operand = rm_ref | (shift_op << 4) | (shift_imm << 4+3)
      else
        raise Asm::AssemblyError.new("invalid operand argument #{arg.inspect}")
      end
    end

    def assemble(io)
      build
      instuction_class = 0b00 # OPC_DATA_PROCESSING
      val = operand.is_a?(Register) ? operand.bits : operand 
      val |= (rd.bits <<            12) 
      val |= (rn.bits <<            12+4)  
      val |= (update_status_flag << 12+4+4)#20 
      val |= (op_bit_code <<        12+4+4  +1)
      val |= (i <<                  12+4+4  +1+4) 
      val |= (instuction_class <<   12+4+4  +1+4+1) 
      val |= (cond_bit_code <<      12+4+4  +1+4+1+2)
      io.write_uint32 val
    end
  end
  class CompareInstruction < LogicInstruction
    def initialize( opcode , args)
      super(opcode , args)
      @update_status_flag = 1
      @rn = args[0]
      @rd = reg "r0"
    end
    def build 
      do_build args[1]
    end
  end
  class MoveInstruction < LogicInstruction
    def initialize( opcode , args)
      super(opcode , args)
      @rn = reg "r0" # register zero = zero bit pattern
    end
    def build
      do_build args[1]
    end
  end
end