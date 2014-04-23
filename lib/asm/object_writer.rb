require 'elf/object_file'
require 'elf/symbol_table_section'
require 'elf/text_section'
require 'elf/string_table_section'

module Asm

  class ObjectWriter
    def initialize(target)
      @object = Elf::ObjectFile.new(target)

      sym_strtab = Elf::StringTableSection.new(".strtab")
      @object.add_section sym_strtab
      @symbol_table = Elf::SymbolTableSection.new(".symtab", sym_strtab)
      @object.add_section @symbol_table

      @text = Elf::TextSection.new(".text")
      @object.add_section @text
    end

    def set_text(text)
      @text.text = text
      add_symbol "_start", 0
    end

    def add_symbol(name, offset, linkage = Elf::Constants::STB_GLOBAL)
      @symbol_table.add_func_symbol name, offset, @text, linkage
    end

    def save(filename)
      to = File.open(filename, 'wb') 
      @object.write to
      to.close
    end

  end
end