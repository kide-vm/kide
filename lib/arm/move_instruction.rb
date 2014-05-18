module Arm

  class MoveInstruction < Vm::MoveInstruction
    include Arm::Constants

    def initialize(first , attributes) 
      super(first , attributes)
      @attributes[:update_status] = 0 if @attributes[:update_status] == nil
      @attributes[:condition_code] = :al if @attributes[:condition_code] == nil
      @attributes[:opcode] = attributes[:opcode]
      @operand = 0

      @immediate = 0      
      @rn = :r0 # register zero = zero bit pattern
    end
    
    # arm intrucions are pretty sensible, and always 4 bytes (thumb not supported)
    def length
      4
    end

    def build
      right = @attributes[:right]
      if right.is_a?(Vm::StringConstant)
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie oc pointing to fetch and not execute)
        right = Vm::IntegerConstant.new( right.position - self.position - 8 )
        @rn = :pc
      end
      if( right.is_a? Fixnum ) #HACK to not have to change the code just now
        right = Vm::IntegerConstant.new( right )
      end
      if (right.is_a?(Vm::IntegerConstant))
        if (right.integer.fits_u8?)
          # no shifting needed
          @operand = right.integer
          @immediate = 1
        elsif (op_with_rot = calculate_u8_with_rr(right))
          @operand = op_with_rot
          @immediate = 1
          raise "hmm"
        else
          raise "cannot fit numeric literal argument in operand #{right.inspect}"
        end
      elsif (right.is_a?(Symbol) or right.is_a?(Vm::Integer))
        @operand = reg_code(right)    #integer means the register the integer is in (otherwise constant)
        @immediate = 0                # ie not immediate is register
      else
        raise "invalid operand argument #{right.inspect} , #{inspect}"
      end
      shift_handling
    end

    def assemble(io)
      build
      instuction_class = 0b00 # OPC_DATA_PROCESSING
      val = shift(@operand , 0)
      val |= shift(reg_code(@first) ,            12)     
      val |= shift(reg_code(@rn) ,            12+4)   
      val |= shift(@attributes[:update_status] , 12+4+4)#20 
      val |= shift(op_bit_code ,        12+4+4  +1)
      val |= shift(@immediate ,                  12+4+4  +1+4) 
      val |= shift(instuction_class ,   12+4+4  +1+4+1) 
      val |= shift(cond_bit_code ,      12+4+4  +1+4+1+2)
      io.write_uint32 val
    end
    def shift val , by
      raise "Not integer #{val}:#{val.class}" unless val.is_a? Fixnum
      val << by
    end
  end
end
