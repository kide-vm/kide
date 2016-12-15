module Arm
  class CompareInstruction < Register::Instruction
    include Constants
    include Attributed

    def initialize(left , right , attributes)
      super(nil)
      @attributes = attributes
      @left = left
      @right = right.is_a?(Fixnum) ? IntegerConstant.new(right) : right
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @operand = 0
      @attributes[:update_status] = 1
      @rn = left
      @rd = :r0
    end

    def assemble(io)
      # don't overwrite instance variables, to make assembly repeatable
      rn , operand , immediate= @rn ,  @operand , 1

      arg = @right
      operand = Register::RegisterValue.new( arg , :Integer) if( arg.is_a? Symbol )
      case operand
      when Numeric
        operand = arg
        raise "numeric literal operand to large #{arg.inspect}" unless (arg.fits_u8?)
      when Symbol , ::Register::RegisterValue
        immediate = 0
      when Arm::Shift
        handle_shift
      else
        raise "invalid operand argument #{arg.inspect} , #{inspect}"
      end
      val = (operand.is_a?(Symbol) or operand.is_a?(::Register::RegisterValue)) ? reg_code(operand) : operand
      val = 0 if val == nil
      val = shift(val , 0)
      raise inspect unless reg_code(@rd)
      val |= shift(reg_code(@rd) ,              12)
      val |= shift(reg_code(rn) ,               12 + 4)
      val |= shift(@attributes[:update_status], 12 + 4 + 4)#20
      val |= shift(op_bit_code ,                12 + 4 + 4  + 1)
      val |= shift(immediate ,                  12 + 4 + 4  + 1 + 4)
      val |= instruction_code
      val |= condition_code
      io.write_uint32 val
    end

    def instuction_class
      0b00 # OPC_DATA_PROCESSING
    end

    # Arms special shift abilities are not modelled in the register level
    # So they would have to be used inoptimisations, that are not implemented
    # in short unused code
    def handle_shift
      # rm_ref = arg.argument
      # immediate = 0
      # shift_op = {'lsl' => 0b000, 'lsr' => 0b010, 'asr' => 0b100,
      #             'ror' => 0b110, 'rrx' => 0b110}[arg.type]
      # if (arg.type == 'ror' and arg.value.nil?)
      #   # ror #0 == rrx
      #   raise "cannot rotate by zero #{arg} #{inspect}"
      # end
      #
      # arg1 = arg.value
      # if (arg1.is_a?(Register::IntegerConstant))
      #   if (arg1.value >= 32)
      #     raise "cannot shift by more than 31 #{arg1} #{inspect}"
      #   end
      #   shift_imm = arg1.value
      # elsif (arg1.is_a?(Arm::Register))
      #   shift_op val |= 0x1;
      #   shift_imm = arg1.number << 1
      # elsif (arg.type == 'rrx')
      #   shift_imm = 0
      # end
      # operand = rm_ref | (shift_op << 4) | (shift_imm << 4 +3)
      raise "No implemented"
    end
    def to_s
      "#{opcode} #{@left} , #{@right} #{super}"
    end
  end
end
