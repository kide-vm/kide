module Arm
  class MoveInstruction < Instruction

    def initialize( to , from , options = {})
      super(nil)
      @attributes = options
      if( from.is_a?(Symbol) and Risc::RiscValue.look_like_reg(from) )
        from = Risc::RiscValue.new(from , :Integer)
      end
      @from = from
      @to = to
      raise "move must have from set #{inspect}" unless from
      @attributes[:update_status] = 1 if @attributes[:update_status] == nil
      @attributes[:update_status] = 0 if @to == :pc
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @rn = :r0 # register zero = zero bit pattern
      @extra = nil
    end
    attr_accessor :to , :from

    # don't overwrite instance variables, to make assembly repeatable
    def assemble(io)
      rn , operand , right , immediate = @rn ,  @operand ,  @from , 1

      case right
      when Numeric
        operand = numeric_operand(right)
      when Risc::RiscValue
        operand = reg_code(right)
        immediate = 0                # ie not immediate is register
      else
        raise "invalid operand argument #{right.class} , #{self.class}"
      end
      op =  shift_handling
      val = shift(operand , 0)
      val |= shift(op , 0) # any barrel action, is already shifted
      val |= shift(reg_code(@to) ,            12)
      val |= shift(reg_code(rn) ,            12 + 4)
      val |= shift(@attributes[:update_status] , 12 + 4 + 4)#20
      val |= shift(op_bit_code ,        12 + 4 + 4  + 1)
      val |= shift(immediate ,          12 + 4 + 4  + 1 + 4)
      val |= instruction_code
      val |= condition_code
      io.write_unsigned_int_32 val
    end

    def instuction_class
      0b00 # OPC_DATA_PROCESSING
    end
    def numeric_operand(right)
      return right if (right.fits_u8?)
      if (op_with_rot = calculate_u8_with_rr(right))
        return op_with_rot
      end
      raise "Negatives not implemented #{right} " if right < 0
      unless @extra
        #puts "RELINK M at #{Risc::Position.get(self)}"
        @extra = 1
        insert ArmMachine.add( to , to , 0 ) #noop that we change below
      end
      # now we can do the actual breaking of instruction, by splitting the operand
      operand = calculate_u8_with_rr( right & 0xFFFFFF00 )
      raise "no fit for #{right}" unless operand
      @next.set_value(right & 0xFF )
      operand
    end
  end
end
