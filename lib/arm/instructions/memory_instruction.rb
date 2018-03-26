module Arm
  # ADDRESSING MODE 2
  # Implemented: immediate offset with offset=0

  class MemoryInstruction < Instruction

    def initialize result , left , right = nil , attributes = {}
      super(nil)
      @attributes = attributes
      @result = result
      @left = left
      @right = right
      @attributes[:update_status] = 1 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @operand = 0
      raise "alert" if right.is_a? Risc::Label
      @add_offset = @attributes[:add_offset] ? 0 : 1 #U flag
      @is_load = opcode.to_s[0] == "l" ? 1 : 0 #L (load) flag
    end

    #str / ldr are _serious instructions. With BIG possibilities not half are implemented
    # don't overwrite instance variables, to make assembly repeatable
    #TODO better test, this operand integer (register) does not work.
    def assemble(io)
      arg = @left
      arg = arg.symbol if( arg.is_a? ::Risc::RiscValue )
      is_reg = arg.is_a?(::Risc::RiscValue)
      is_reg = (arg.to_s[0] == "r") if( arg.is_a?(Symbol) and not is_reg)

      raise "invalid operand argument #{arg.inspect} #{inspect}" unless (is_reg )
      operand = get_operand

      #not sure about these 2 constants. They produce the correct output for str r0 , r1
      # but i can't help thinking that that is because they are not used in that instruction and
      # so it doesn't matter. Will see
      if (operand.is_a?(Symbol) or operand.is_a?(::Risc::RiscValue))
        val = reg_code(operand)
        i = 1  # not quite sure about this, but it gives the output of as. read read read.
      else
        i = 0 #I flag (third bit)
        val = operand
      end
      # testing against gnu as, setting the flag produces correct output
      # but gnu as produces same output for auto_inc or not, so that seems broken
      # luckily auto_inc is not used and even if it clobbers unused reg in soml, but still

      val = shift(val , 0 )
      val |= shift(reg_code(arg) ,  16)
      val |= shift(i ,              25)
      write_val(val, io)
    end

    def write_val(val, io)
      val |= shift(shift_handling , 0)
      val |= shift(reg_code(@result) , 12 )
      val |= shift(@is_load ,       20)
      val |= shift(byte_access ,    22)
      val |= shift(add_offset ,     23)
      val |= shift(0, 21)
      val |= shift(1, 24) #pre_post index , not used
      val |= instruction_code
      val |= condition_code
      io.write_unsigned_int_32 val
    end
    def get_operand
      return @operand unless  @right
      operand = @right
      operand = operand.symbol if operand.is_a? ::Risc::RiscValue
      unless( operand.is_a? Symbol)
        # TODO test/check/understand: has no effect in current tests
        # add_offset = (operand < 0) ? 0 : 1
        operand *= -1 if (operand < 0)
        raise "offset too large (max 4095) #{arg} #{inspect}" if (@operand.abs > 4095)
      end
      operand
    end
    def instuction_class
      0b01 # OPC_MEMORY_ACCESS
    end
    def add_offset
      @attributes[:add_offset] ? 0 : 1
    end

    def byte_access
      opcode.to_s[-1] == "b" ? 1 : 0 #B (byte) flag
    end
  end
end
