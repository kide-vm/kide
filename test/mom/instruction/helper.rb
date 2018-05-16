require_relative '../helper'

module Mom
  class CompilerMock
    def use_reg( type )
      Risc.tmp_reg(type , nil)
    end
    def reset_regs

    end
    def add_constant(c)
    end
  end
  class InstructionMock < Instruction
  end
end
