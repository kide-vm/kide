module Elf
  class TextSection < Section
    attr_accessor :text

    def write(io)
      io << text
    end

    def type
      Elf::Constants::SHT_PROGBITS
    end

    def flags
      Elf::Constants::SHF_ALLOC | Elf::Constants::SHF_EXECINSTR
    end
  
    def alignment
      4
    end
  end
end
