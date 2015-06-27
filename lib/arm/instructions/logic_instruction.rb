module Arm
  class LogicInstruction < Instruction
    include Arm::Constants
    #  result = left op right
    #
    # Logic instruction are your basic operator implementation. But unlike the (normal) code we write
    #    these Instructions must have "place" to write their results. Ie when you write 4 + 5 in ruby
    #    the result is sort of up in the air, but with Instructions the result must be assigned
    def initialize(result , left , right , attributes = {})
      super(attributes)
      @result = result
      @left = left
      @right = right
      @attributes[:update_status] = 0 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @operand = 0

      raise "Left arg must be given #{inspect}" unless @left
      @immediate = 0
    end

    attr_accessor :result , :left ,  :right
    def assemble(io)
      # don't overwrite instance variables, to make assembly repeatable
      left = @left
      operand = @operand
      immediate = @immediate

      right = @right
      if @left.is_a?(Parfait::Object) or
        @left.is_a?(Symbol) and !Register::RegisterReference.look_like_reg(@left)
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie pointing to fetch and not execute)
        right = @left.position - self.position - 8
        raise "todo in direction #{right}" if( opcode == :add and right < 0 )
        raise "No negatives implemented #{right} " if right < 0
        left = :pc
      end
      if (right.is_a?(Numeric))
        if (right.fits_u8?)
          # no shifting needed
          operand = right
          immediate = 1
        elsif (op_with_rot = calculate_u8_with_rr(right))
          operand = op_with_rot
          immediate = 1
        else
          #TODO this is copied from MoveInstruction, should rework
          unless @extra
            @extra = 1
            raise ::Register::LinkException.new("cannot fit numeric literal argument in operand #{right.inspect}")
          end
          # now we can do the actual breaking of instruction, by splitting the operand
          first = right & 0xFFFFFF00
          operand = calculate_u8_with_rr( first )
          raise "no fit for #{right}" unless operand
          immediate = 1
          @extra = ArmMachine.add( result , result , (right & 0xFF) )
        end
      elsif (right.is_a?(Symbol) or right.is_a?(::Register::RegisterReference))
        operand = reg_code(right)    #integer means the register the integer is in (otherwise constant)
        immediate = 0                # ie not immediate is register
      else
        raise "invalid operand argument #{right.inspect} , #{inspect}"
      end
      op =  shift_handling
      instuction_class = 0b00 # OPC_DATA_PROCESSING
      val = shift(operand , 0)
      val |= shift(op , 0) # any barral action, is already shifted
      val |= shift(reg_code(@result) ,            12)
      val |= shift(reg_code(left) ,            12+4)
      val |= shift(@attributes[:update_status] , 12+4+4)#20
      val |= shift(op_bit_code ,        12+4+4  + 1)
      val |= shift(immediate ,                  12+4+4  + 1+4)
      val |= shift(instuction_class ,   12+4+4  + 1+4+1)
      val |= shift(cond_bit_code ,      12+4+4  + 1+4+1+2)
      io.write_uint32 val
      # by now we have the extra add so assemble that
      if(@extra)
        @extra.assemble(io)
        #puts "Assemble extra at #{val.to_s(16)}"
      end
    end

    def shift val , by
      raise "Not integer #{val}:#{val.class} #{inspect}" unless val.is_a? Fixnum
      val << by
    end

    def word_length
      @extra ? 8 : 4
    end

    def uses
      ret = []
      ret << @left.register if @left and not @left.is_a? Constant
      ret << @right.register if @right and not @right.is_a?(Constant)
      ret
    end
    def assigns
      [@result.register]
    end
  end
end
