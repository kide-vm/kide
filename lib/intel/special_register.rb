require 'intel/register'
require 'intel/operand'

module Intel
  ##
  # SpecialRegister is the abstract implementation of any kind of
  # register that isn't a general register, eg: segment registers, mmx
  # registers, fpu registers, etc...

  class SpecialRegister < Operand
    attr_accessor :id

    def initialize machine = nil, id = nil , bits = nil
      super(machine,bits)
      self.id = id
    end

  end

  ##
  # DebugRegister is an X86 DRx register

  class DebugRegister < SpecialRegister
  end

  ##
  # TestRegister is an X86 Test Register, TRx

  class TestRegister < SpecialRegister
  end
  ##
  # FPURegister is an X86 fpureg, STx

  class FPURegister < SpecialRegister
  end

  ##
  # ControlRegister is an X86 CRx register

  class ControlRegister < SpecialRegister
  end

  ##
  # MMXRegister is an X86 MMX register

  class MMXRegister < SpecialRegister

    def push_mod_rm_on spareRegister, stream
      stream << (0b11000000 + id + (spareRegister.id << 3))
    end
  end
  ##
  # SegmentRegister is an X86 segment register, eg: ss, cs, ds, es...

  class SegmentRegister < SpecialRegister
  end
end
