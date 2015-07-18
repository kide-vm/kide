module Arm
  class CompareInstruction < Instruction
    include Arm::Constants

    def initialize(left , right , attributes)
      super(attributes)
      @left = left
      @right = right.is_a?(Fixnum) ? IntegerConstant.new(right) : right
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @operand = 0
      @immediate = 0
      @attributes[:update_status] = 1
      @rn = left
      @rd = :r0
    end

    def assemble(io)
      # don't overwrite instance variables, to make assembly repeatable
      rn = @rn
      operand = @operand
      immediate = @immediate

      arg = @right
      if arg.is_a?(Parfait::Object)
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie oc pointing to fetch and not execute)
        arg =  arg.position - self.position - 8
        rn = :pc
      end
      if( arg.is_a? Symbol )
        arg = Register::RegisterReference.new( arg )
      end
      if (arg.is_a?(Numeric))
        if (arg.fits_u8?)
          # no shifting needed
          operand = arg
          immediate = 1
        elsif (op_with_rot = calculate_u8_with_rr(arg))
          operand = op_with_rot
          immediate = 1
          raise "hmm"
        else
          raise "cannot fit numeric literal argument in operand #{arg.inspect}"
        end
      elsif (arg.is_a?(Symbol) or arg.is_a?(::Register::RegisterReference))
        operand = arg
        immediate = 0
      elsif (arg.is_a?(Arm::Shift))
        rm_ref = arg.argument
        immediate = 0
        shift_op = {'lsl' => 0b000, 'lsr' => 0b010, 'asr' => 0b100,
                    'ror' => 0b110, 'rrx' => 0b110}[arg.type]
        if (arg.type == 'ror' and arg.value.nil?)
          # ror #0 == rrx
          raise "cannot rotate by zero #{arg} #{inspect}"
        end

        arg1 = arg.value
        if (arg1.is_a?(Virtual::IntegerConstant))
          if (arg1.value >= 32)
            raise "cannot shift by more than 31 #{arg1} #{inspect}"
          end
          shift_imm = arg1.value
        elsif (arg1.is_a?(Arm::Register))
          shift_op val |= 0x1;
          shift_imm = arg1.number << 1
        elsif (arg.type == 'rrx')
          shift_imm = 0
        end
        operand = rm_ref | (shift_op << 4) | (shift_imm << 4+3)
      else
        raise "invalid operand argument #{arg.inspect} , #{inspect}"
      end
      instuction_class = 0b00 # OPC_DATA_PROCESSING
      val = (operand.is_a?(Symbol) or operand.is_a?(::Register::RegisterReference)) ? reg_code(operand) : operand
      val = 0 if val == nil
      val = shift(val , 0)
      raise inspect unless reg_code(@rd)
      val |= shift(reg_code(@rd) ,            12)
      val |= shift(reg_code(rn) ,            12+4)
      val |= shift(@attributes[:update_status] , 12+4+4)#20
      val |= shift(op_bit_code ,        12+4+4  +1)
      val |= shift(immediate ,                  12+4+4  +1+4)
      val |= shift(instuction_class ,   12+4+4  +1+4+1)
      val |= shift(cond_bit_code ,      12+4+4  +1+4+1+2)
      io.write_uint32 val
    end
    def shift val , by
      raise "Not integer #{val}:#{val.class} #{inspect}" unless val.is_a? Fixnum
      val << by
    end

    def uses
      ret = [@left.register ]
      ret << @right.register unless @right.is_a? Constant
      ret
    end
    def assigns
      []
    end
    def to_s
      "#{opcode} #{@left} , #{@right} #{super}"
    end
  end
end
