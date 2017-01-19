module Arm
  class LogicInstruction < Risc::Instruction
    include Constants
    include Attributed

    #  result = left op right   #or constant loading
    #
    # Logic instruction are your basic operator implementation. But unlike the (normal) code we write
    #    these Instructions must have "place" to write their results. Ie when you write 4 + 5 in ruby
    #    the result is sort of up in the air, but with Instructions the result must be assigned
    def initialize(result , left , right , attributes = {})
      super(nil)
      @attributes = attributes
      @result = result
      @left = left
      @right = right
      @attributes[:update_status] = 1 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      raise "Left arg must be given #{inspect}" unless @left
    end

    attr_accessor :result , :left ,  :right
    def assemble(io)
      left , right = determine_operands
      immediate = 1 # default, unless register (below)

      if (right.is_a?(Numeric))
        operand = handle_numeric(right)
      elsif (right.is_a?(Symbol) or right.is_a?(::Risc::RiscValue))
        operand = reg_code(right)    #integer means the register the integer is in (otherwise constant)
        immediate = 0                # ie not immediate is register
      else
        raise "invalid operand argument #{right.inspect} , #{inspect}"
      end
      left_code = reg_code(left)
      op =  shift_handling
      if( opcode == :mul )
        operand = reg_code(left) + 0x90
        op = reg_code(right) << 8
        left_code = reg_code(@result)
      end
      val = shift(operand , 0)
      val |= shift(op , 0) # any barrel action, is already shifted
      val |= shift(result ,            12)
      val |= shift(left_code ,         12 + 4)
      val |= shift(@attributes[:update_status] , 12 + 4 + 4)#20
      val |= shift(op_bit_code ,       12 + 4 + 4  + 1)
      val |= shift(immediate ,         12 + 4 + 4  + 1 + 4)
      val |= instruction_code
      val |= condition_code
      io.write_unsigned_int_32 val
      assemble_extra(io)
    end

    def result
      opcode == :mul ? 0 : reg_code(@result)
    end

    def instuction_class
      0b00 # OPC_DATA_PROCESSING
    end

    # Arm can't load any large (over 1024) numbers, or larger with fancy shifting,
    # but then the lower bits must be 0's. Especially in constant loading random large numbers
    # happen, and so they are split into two instructions. An exection is thrown, that triggers
    # some position handling and an @extra add instruction generated.
    def handle_numeric(right)
      if (right.fits_u8?)
        operand = right # no shifting needed
      elsif (op_with_rot = calculate_u8_with_rr(right))
        operand = op_with_rot
      else
        unless @extra
          @extra = 1
          #puts "RELINK L at #{self.position.to_s(16)}"
          raise ::Risc::LinkException.new("cannot fit numeric literal argument in operand #{right.inspect}")
        end
        # now we can do the actual breaking of instruction, by splitting the operand
        operand = calculate_u8_with_rr( right & 0xFFFFFF00 )
        raise "no fit for #{right}" unless operand
        # use sub for sub and add for add, ie same as opcode
        @extra = ArmMachine.send( opcode ,  result , result , (right & 0xFF) )
      end
      return operand
    end

    # don't overwrite instance variables, to make assembly repeatable
    # this also loads constants, which are issued as pc relative adds
    def determine_operands
      if( @left.is_a?(Parfait::Object) or @left.is_a?(Risc::Label) or
        (@left.is_a?(Symbol) and !Risc::RiscValue.look_like_reg(@left)))
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie pointing to fetch and not execute)
        right = Positioned.position(@left) - Positioned.position(self) - 8
        if( (right < 0) && ((opcode == :add) || (opcode == :sub)) )
          right *= -1   # this works as we never issue sub only add
          set_opcode :sub  # so (as we can't change the sign permanently) we can change the opcode
        end                         # and the sign even for sub (becuase we created them)
        raise "No negatives implemented #{self} #{right} " if right < 0
        return :pc , right
      else
        return @left , @right
      end
    end

    # by now we have the extra add so assemble that
    def assemble_extra(io)
      return unless @extra
      if(@extra == 1) # unles things have changed and then we add a noop (to keep the length same)
        @extra = ArmMachine.mov( :r1 , :r1  )
      end
      @extra.assemble(io)
      #puts "Assemble extra at #{val.to_s(16)}"
    end

    def byte_length
      @extra ? 8 : 4
    end

    def to_s
      "#{self.class.name} #{opcode} #{@result} = #{@left} #{@right}  extra=#{@extra}"
    end
  end
end
