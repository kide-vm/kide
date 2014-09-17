require 'elf/object_file'
require 'elf/symbol_table_section'
require 'elf/text_section'
require 'elf/string_table_section'

module Elf

  class ObjectWriter
    def initialize(space , target = Elf::Constants::TARGET_ARM )
      @object = Elf::ObjectFile.new(target)
      @object_space = space
      sym_strtab = Elf::StringTableSection.new(".strtab")
      @object.add_section sym_strtab
      @symbol_table = Elf::SymbolTableSection.new(".symtab", sym_strtab)
      @object.add_section @symbol_table

      @text = Elf::TextSection.new(".text")
      @object.add_section @text
      
      @object_space.run_passes
      assembler = Register::Assembler.new(@object_space)
      set_text assembler.assemble      

      # for debug add labels to the block positions 
      blocks = []
      space.classes.values.each do |clazz| 
        clazz.instance_methods.each do |f|
          f.blocks.each do |b|
              add_symbol "#{clazz.name}::#{f.name}@#{b.name}" , b.position
            end
        end
      end
      assembler.objects.values.each do |slot| 
        add_symbol "#{slot.class.name}::#{slot.position.to_s(16)}" , slot.position
      end
    end
    attr_reader :text
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