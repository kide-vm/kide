module Elf
  class TextSection < Section
    attr_accessor :text

    def write(io)
      io << text
    end

    def type
      Elf::Constants::SHT_PROGBITS
    end

    def flags #making the text writable !gogogo
      Elf::Constants::SHF_WRITE | Elf::Constants::SHF_ALLOC | Elf::Constants::SHF_EXECINSTR
    end
  
    def length
      @text.length
    end
    def to_s
      "[" + @text.bytes.join(",") + "]"
    end
    def alignment
      4
    end
  end
end
