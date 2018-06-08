require_relative "../helper"

module Risc
  class Dummy
    def padded_length
      4
    end
    def byte_length
      4
    end
  end
  class Machine
    def set_platform(plat)
      @platform = plat
    end
    def set_translated
      @translated = true
      translate_methods( @platform.translator )
      @cpu_init = risc_init.to_cpu(@platform.translator)
    end
  end
  class DummyPlatform
    def self.boot
      machine = Risc.machine.boot
      machine.set_platform( self.new )
      machine
    end
    def translator
      DummyTranslator.new
    end
    def padding
      0
    end
  end
  class DummyTranslator
    def translate(arg)
      DummyInstruction.new
    end
  end
  class DummyInstruction < Dummy
    include Util::List
    def initialize(nekst = nil)
      @next = nekst
    end
    def insert(instruction)
      ret = super
      Position.get(self).trigger_inserted if Position.set?(self)
      ret
    end
    def assemble(io)
      io.write_unsigned_int_32(0)
    end
    def total_byte_length
      4
    end
  end
end
