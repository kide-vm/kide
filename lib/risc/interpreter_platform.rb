
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
      self
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
      case code
      when Branch
        new_label = code.label.is_a?(Label) ? code.label.to_cpu(self) : code.label
        ret = code.class.new(code.source , new_label)
      when LoadConstant
        const = code.constant
        const = const.to_cpu(self) if const.is_a?(Label)
        ret = LoadConstant.new(code.source , const , code.register)
      else
        ret = code.dup
      end
      ret.nil_next
      ret
    end
  end
end
