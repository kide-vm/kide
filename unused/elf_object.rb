if (__FILE__ == $0)
  obj = Elf::ObjectFile.new Elf::TARGET_ARM

  sym_strtab = Elf::StringTableSection.new(".strtab")
  obj.add_section sym_strtab
  symtab = Elf::SymbolTableSection.new(".symtab", sym_strtab)
  obj.add_section symtab

  text_section = Elf::TextSection.new(".text")
  obj.add_section text_section

  symtab.add_func_symbol "_start", 0, text_section, Elf::STB_GLOBAL

  fp = File.open("test.o", "wb")
  obj.write fp

  fp.close
end

