module Elf
  class RelocationTableSection < Section
    def initialize(name, symtab, text_section)
      super(name)

      @symtab = symtab
      @text_section = text_section

      @relocs = []
    end

    def add_reloc(offset, name, type)
      @relocs << [offset, name, type]
    end

    def type
      Elf::Constants::SHT_REL
    end

    def ent_size
      8
    end

    def link
      @symtab.index
    end

    def info
      @text_section.index
    end

    def write(io)
      @relocs.each { |reloc|
        name_idx = @symtab.index_for_name(reloc[1])
        io.write_uint32 reloc[0]
        # +1 because entry number 0 is und
        io.write_uint32 reloc[2] | ((name_idx+1) << 8)
      }
    end
  end
end
