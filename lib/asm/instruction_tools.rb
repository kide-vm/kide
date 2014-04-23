module Asm

    module InstructionTools
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
      OPC_DATA_PROCESSING = 0b00
      OPC_MEMORY_ACCESS = 0b01
      OPC_STACK = 0b10
      
      def reg_ref(arg)
        if (not arg.is_a?(Asm::Register))
          raise Asm::AssemblyError.new('argument must be a register', arg)
        end

        ref =
        {'r0' => 0, 'r1' => 1, 'r2' => 2, 'r3' => 3, 'r4' => 4, 'r5' => 5,
         'r6' => 6, 'r7' => 7, 'r8' => 8, 'r9' => 9, 'r10' => 10, 'r11' => 11,
         'r12' => 12, 'r13' => 13, 'r14' => 14, 'r15' => 15, 'a1' => 0, 'a2' => 1,
         'a3' => 2, 'a4' => 3, 'v1' => 4, 'v2' => 5, 'v3' => 6, 'v4' => 7, 'v5' => 8,
         'v6' => 9, 'rfp' => 9, 'sl' => 10, 'fp' => 11, 'ip' => 12, 'sp' => 13,
         'lr' => 14, 'pc' => 15}[arg.name.downcase]

        if (not ref)
          raise Asm::AssemblyError.new('unknown register %s' % arg.name.downcase, arg)
        end

        ref
      end
    end
end