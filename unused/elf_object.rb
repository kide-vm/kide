if (__FILE__ == $0)
  obj = ELF::ObjectFile.new ELF::TARGET_ARM

  sym_strtab = ELF::StringTableSection.new(".strtab")
  obj.add_section sym_strtab
  symtab = ELF::SymbolTableSection.new(".symtab", sym_strtab)
  obj.add_section symtab

  text_section = ELF::TextSection.new(".text")
  obj.add_section text_section

  symtab.add_func_symbol "_start", 0, text_section, ELF::STB_GLOBAL

  fp = File.open("test.o", "wb")
  obj.write fp

  fp.close
end

