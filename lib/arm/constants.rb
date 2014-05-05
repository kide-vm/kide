module Arm

  module Constants
    OPCODES = {
      :adc => 0b0101, :add => 0b0100,
      :and => 0b0000, :bic => 0b1110,
      :eor => 0b0001, :orr => 0b1100,
      :rsb => 0b0011, :rsc => 0b0111,
      :sbc => 0b0110, :sub => 0b0010,

      # for these Rn is sbz (should be zero)
      :mov => 0b1101,
      :mvn => 0b1111,
      # for these Rd is sbz and S=1
      :cmn => 0b1011,
      :cmp => 0b1010,
      :teq => 0b1001,
      :tst => 0b1000,

      :b => 0b1010,
      :bl => 0b1011,
      :bx => 0b00010010
    }
    #return the bit patter that the cpu uses for the current instruction @opcode
    def op_bit_code
      OPCODES[@opcode] or throw "no code found for #{@opcode.inspect}"
    end

    #codition codes can be applied to many instructions and thus save branches
    # :al => always   , :eq => equal  and so on
    # eq mov if equal :moveq r1 r2 (also exists as function) will only execute if the last operation was 0
    COND_CODES = {
      :al => 0b1110, :eq => 0b0000,
      :ne => 0b0001, :cs => 0b0010,
      :mi => 0b0100, :hi => 0b1000,
      :cc => 0b0011, :pl => 0b0101,
      :ls => 0b1001, :vc => 0b0111,
      :lt => 0b1011, :le => 0b1101,
      :ge => 0b1010, :gt => 0b1100,
      :vs => 0b0110
    }
    #return the bit pattern for the @condition_code variable, which signals the conditional code
    def cond_bit_code
      COND_CODES[@condition_code] or throw "no code found for #{@condition_code}"
    end
    
    REGISTERS = { 'r0' => 0, 'r1' => 1, 'r2' => 2, 'r3' => 3, 'r4' => 4, 'r5' => 5,
                  'r6' => 6, 'r7' => 7, 'r8' => 8, 'r9' => 9, 'r10' => 10, 'r11' => 11,
                  'r12' => 12, 'r13' => 13, 'r14' => 14, 'r15' => 15, 'a1' => 0, 'a2' => 1,
                  'a3' => 2, 'a4' => 3, 'v1' => 4, 'v2' => 5, 'v3' => 6, 'v4' => 7, 'v5' => 8,
                  'v6' => 9, 'rfp' => 9, 'sl' => 10, 'fp' => 11, 'ip' => 12, 'sp' => 13,
                  'lr' => 14, 'pc' => 15 }
    def reg name
      code = reg_code name
      raise "no such register #{name}" unless code
      Arm::Register.new(name.to_sym , code )
    end
    def reg_code name
      REGISTERS[name.to_s]
    end

   def calculate_u8_with_rr(arg)
     parts = arg.value.to_s(2).rjust(32,'0').scan(/^(0*)(.+?)0*$/).flatten
     pre_zeros = parts[0].length
     imm_len = parts[1].length
     if ((pre_zeros+imm_len) % 2 == 1)
       u8_imm = (parts[1]+'0').to_i(2)
       imm_len += 1
     else
       u8_imm = parts[1].to_i(2)
     end
     if (u8_imm.fits_u8?)
       # can do!
       rot_imm = (pre_zeros+imm_len) / 2
       if (rot_imm > 15)
         return nil
       end
       return u8_imm | (rot_imm << 8)
     else
       return nil
     end
   end
  end
end