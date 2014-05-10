
module Arm
  # Many arm instructions may be conditional, where the default condition is always (al)
  # ArmMachine::COND_CODES names them, and this attribute reflects it
  #attr_reader :condition_code
  #attr_reader :operand

  # Logic instructions may be executed with or without affecting the status register
  # Only when an instruction affects the status is a subsequent compare instruction effective
  # But to make the conditional execution (see cond) work for more than one instruction, one needs to
  # be able to execute without changing the status 
  #attr_reader :update_status_flag
  
  module LogicHelper
    # ADDRESSING MODE 1 
    # Logic ,Maths, Move and compare instructions (last three below)
    
    # arm intrucioons are pretty sensible, and always 4 bytes (thumb not supported)
    def length
      4
    end

    #(stays in subclases, while build is overriden to provide different arguments)
    def do_build(arg)      
      if arg.is_a?(Vm::StringLiteral)
        # do pc relative addressing with the difference to the instuction
        # 8 is for the funny pipeline adjustment (ie oc pointing to fetch and not execute)
        arg = Arm::NumLiteral.new( arg.position - self.position - 8 )
        @rn = :pc
      end
      if( arg.is_a? Fixnum ) #HACK to not have to change the code just now
        arg = Arm::NumLiteral.new( arg )
      end
      if( arg.is_a? Vm::Signed ) #HACK to not have to change the code just now
        arg = Arm::NumLiteral.new( arg.value )
      end
      if (arg.is_a?(Arm::NumLiteral))
        if (arg.value.fits_u8?)
          # no shifting needed
          @operand = arg.value
          @i = 1
        elsif (op_with_rot = calculate_u8_with_rr(arg))
          @operand = op_with_rot
          @i = 1
        else
          raise "cannot fit numeric literal argument in operand #{arg.inspect}"
        end
      elsif (arg.is_a?(Symbol))
        @operand = arg
        @i = 0
      elsif (arg.is_a?(Arm::Shift))
        rm_ref = arg.argument
        @i = 0
        shift_op = {'lsl' => 0b000, 'lsr' => 0b010, 'asr' => 0b100,
                    'ror' => 0b110, 'rrx' => 0b110}[arg.type]
        if (arg.type == 'ror' and arg.value.nil?)
          # ror #0 == rrx
          raise "cannot rotate by zero #{arg} #{inspect}"
        end
    
        arg1 = arg.value
        if (arg1.is_a?(Arm::NumLiteral))
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
        @operand = rm_ref | (shift_op << 4) | (shift_imm << 4+3)
      else
        raise "invalid operand argument #{arg.inspect} , #{inspect}"
      end
    end

    def assemble(io)
      build
      instuction_class = 0b00 # OPC_DATA_PROCESSING
      val = @operand.is_a?(Symbol) ? reg_code(@operand) : @operand 
      raise inspect unless reg_code(@rd)
      val |= (reg_code(@rd) <<            12)     
      val |= (reg_code(@rn) <<            12+4)   
      val |= (@attributes[:update_status_flag] << 12+4+4)#20 
      val |= (op_bit_code <<        12+4+4  +1)
      val |= (@i <<                  12+4+4  +1+4) 
      val |= (instuction_class <<   12+4+4  +1+4+1) 
      val |= (cond_bit_code <<      12+4+4  +1+4+1+2)
      io.write_uint32 val
    end
  end
end