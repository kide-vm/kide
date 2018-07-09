require_relative '../helper'

module Mom
  class CompilerMock
    # resolve a symbol to a type. Allowed symbols are :frame , :receiver and arguments
    # which return the respective types, otherwise nil
    def resolve_type( name )
        return nil
    end
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
