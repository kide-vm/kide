
module Risc
  class InterpreterPlatform
    def translator
      IdentityTranslator.new
    end
    def loaded_at
      0x90
    end
    def padding
      0x100 - loaded_at
    end
  end
  class Instruction
    def nil_next
      @next = nil
    end
    def byte_length
      4
    end
    def assemble(io)
      pos = Position.get(self).at
      io.write_unsigned_int_32(pos)
    end
    class Branch < Instruction
      def first #some logging assumes arm
        self
      end
    end
  end
  class IdentityTranslator
    def translate(code)
      #return Label.new( code.source , code.name ) if code.is_a?(Label)
      if( code.is_a?(Branch))
        return code.class.new(code.source , code.label.to_cpu(self))
      end
      ret = code.dup
      ret.nil_next
      ret
    end
  end
end
