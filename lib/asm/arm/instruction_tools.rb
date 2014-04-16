module Asm
  module Arm
    module InstructionTools
      def reg_ref(arg)
        if (not arg.is_a?(Asm::RegisterArgNode))
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
end