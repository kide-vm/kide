module Elf
  class SymbolTableSection < Section
    def initialize(name, strtab)
      super(name)

      @strtab = strtab

      @symbols = []
    end

    def add_func_symbol(name, value, text_section, linkage)
      @strtab.add_string name
      arr = [name, value, text_section, linkage]
      if (linkage == Elf::Constants::STB_LOCAL)
        @symbols.unshift arr
      else
        @symbols.push arr
      end
    end

    def has_name(name)
      @strtab.index_for(name)
    end
    
    def index_for_name(name)
      @symbols.each_with_index { |sym, idx|
        if (sym[0] == name)
          return idx
        end
      }
      nil
    end

    def type
      Elf::Constants::SHT_SYMTAB
    end

    def ent_size
      16
    end

    def link
      @strtab.index
    end

    def info
      i = -1
      @symbols.each_with_index { |sym, idx|
        if (sym[4] == Elf::Constants::STB_LOCAL)
          i = idx
        end
      }
      i + 1
    end

    def write(io)
      # write undefined symbol
      io.write_unsigned_int_32 0
      io.write_unsigned_int_32 0
      io.write_unsigned_int_32 0
      io.write_unsigned_int_8 Elf::Constants::STB_LOCAL << 4
      io.write_unsigned_int_8 0
      io.write_unsigned_int_16 0

      # write other symbols
      @symbols.each { |sym|
        io.write_unsigned_int_32 @strtab.index_for(sym[0])
        io.write_unsigned_int_32 sym[1]
        io.write_unsigned_int_32 0
        io.write_unsigned_int_8((sym[3] << 4) + 0)
        io.write_unsigned_int_8 0
        if (sym[2])
          io.write_unsigned_int_16 sym[2].index
        else
          # undefined symbol
          io.write_unsigned_int_16 0
        end
      }
    end
  end
end
