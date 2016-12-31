module Arm
  class MoveInstruction < Register::Instruction
    include Constants
    include Attributed

    def initialize to , from , options = {}
      super(nil)
      @attributes = options
      if( from.is_a?(Symbol) and Register::RegisterValue.look_like_reg(from) )
        from = Register::RegisterValue.new(from , :Integer)
      end
      @from = from
      @to = to
      raise "move must have from set #{inspect}" unless from
      @attributes[:update_status] = 1 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @rn = :r0 # register zero = zero bit pattern
      @extra = nil
    end
    attr_accessor :to , :from

    # arm intructions are pretty sensible, and always 4 bytes (thumb not supported)
    # but not all constants fit into the part of the instruction that is left after the instruction
    # code, so large moves have to be split into two instructions.
    # we handle this "transparently", just this instruction looks longer
    # alas, full transparency is not achieved as we only know when to use 2 instruction once we
    # know where the other object is, and that position is only set after code positions have been
    # determined (in link) and so see below in assemble
    def byte_length
      @extra ? 8 : 4
    end

    # don't overwrite instance variables, to make assembly repeatable
    def assemble(io)
      rn , operand , right , immediate = @rn ,  @operand ,  @from , 1

      case right
      when Numeric
        operand = numeric_operand(right)
      when Register::RegisterValue
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
      # by now we have the extra add so assemble that
      @extra.assemble(io) if(@extra) #puts "Assemble extra at #{val.to_s(16)}"
    end

    def instuction_class
      0b00 # OPC_DATA_PROCESSING
    end
    def numeric_operand(right)
      return right if (right.fits_u8?)
      if (op_with_rot = calculate_u8_with_rr(right))
        return op_with_rot
      end
      raise "No negatives implemented #{right} " if right < 0
      unless @extra
        @extra = 1      # puts "RELINK M at #{self.position.to_s(16)}"
        raise ::Register::LinkException.new("cannot fit numeric literal argument in operand #{right.inspect}")
      end
      # now we can do the actual breaking of instruction, by splitting the operand
      operand = calculate_u8_with_rr( right & 0xFFFFFF00 )
      raise "no fit for #{right}" unless operand
      @extra = ArmMachine.add( to , to , (right & 0xFF) )
      operand
    end
  end
end
