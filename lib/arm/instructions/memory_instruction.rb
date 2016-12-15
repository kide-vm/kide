module Arm
  # ADDRESSING MODE 2
  # Implemented: immediate offset with offset=0

  class MemoryInstruction < Register::Instruction
    include Constants
    include Attributed

    def initialize result , left , right = nil , attributes = {}
      super(nil)
      @attributes = attributes
      @result = result
      @left = left
      @right = right
      @attributes[:update_status] = 1 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @operand = 0
      raise "alert" if right.is_a? Register::Label
      @pre_post_index = @attributes[:pre_post_index] ? 0 : 1  #P flag
      @add_offset = @attributes[:add_offset] ? 0 : 1 #U flag
      @is_load = opcode.to_s[0] == "l" ? 1 : 0 #L (load) flag
    end

    def assemble(io)
      # don't overwrite instance variables, to make assembly repeatable
      rn , operand , add_offset , arg = @rn , @operand , @add_offset , @left
      arg = arg.symbol if( arg.is_a? ::Register::RegisterValue )
      #str / ldr are _serious instructions. With BIG possibilities not half are implemented
      is_reg = arg.is_a?(::Register::RegisterValue)
      if( arg.is_a?(Symbol) and not is_reg)
        is_reg = (arg.to_s[0] == "r")
      end
      if (is_reg ) #symbol is register
        rn = arg
        if @right
          operand = @right
          #TODO better test, this operand integer (register) does not work. but sleep first
          operand = operand.symbol if operand.is_a? ::Register::RegisterValue
          unless( operand.is_a? Symbol)         #TODO test/check/understand
            add_offset = (operand < 0) ? 0 : 1
            operand *= -1 if (operand < 0)
            raise "offset too large (max 4095) #{arg} #{inspect}" if (@operand.abs > 4095)
          end
        end
      elsif (arg.is_a?(Parfait::Object) or arg.is_a? Symbol ) #use pc relative
        rn = :pc
        operand = arg.position - self.position  - 8 #stringtable is after code
        add_offset = 1
        if (operand.abs > 4095)
          raise "reference offset too large/small (4095<#{operand}) #{arg} #{inspect}"
        end
      else
        raise "invalid operand argument #{arg.inspect} #{inspect}"
      end
      #not sure about these 2 constants. They produce the correct output for str r0 , r1
      # but i can't help thinking that that is because they are not used in that instruction and
      # so it doesn't matter. Will see
      if (operand.is_a?(Symbol) or operand.is_a?(::Register::RegisterValue))
        val = reg_code(operand)
        @pre_post_index = 0
        i = 1  # not quite sure about this, but it gives the output of as. read read read.
      else
        i = 0 #I flag (third bit)
        val = operand
      end
      # testing against gnu as, setting the flag produces correct output
      # but gnu as produces same output for auto_inc or not, so that seems broken
      # luckily auto_inc is not used and even if it clobbers unused reg in soml, but still
      @pre_post_index = 1
      op =  shift_handling
      val = shift(val , 0 ) # for the test
      val |= shift(op , 0)
      val |= shift(reg_code(@result) , 12 )
      val |= shift(reg_code(rn) ,   12 + 4) #16
      val |= shift(@is_load ,       12 + 4  + 4)
      val |= shift(0 ,              12 + 4  + 4 + 1)
      val |= shift(byte_access ,    12 + 4  + 4 + 1 + 1)
      val |= shift(add_offset ,     12 + 4  + 4 + 1 + 1 + 1)
      val |= shift(@pre_post_index, 12 + 4  + 4 + 1 + 1 + 1 + 1)#24
      val |= shift(i ,              12 + 4  + 4 + 1 + 1 + 1 + 1  + 1)
      val |= instruction_code
      val |= condition_code
      io.write_uint32 val
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
