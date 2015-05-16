require 'elf/object_file'
require 'elf/symbol_table_section'
require 'elf/text_section'
require 'elf/string_table_section'

module Elf

  class ObjectWriter
    def initialize(machine , target = Elf::Constants::TARGET_ARM )
      @object = Elf::ObjectFile.new(target)
      @object_machine = machine
      sym_strtab = Elf::StringTableSection.new(".strtab")
      @object.add_section sym_strtab
      @symbol_table = Elf::SymbolTableSection.new(".symtab", sym_strtab)
      @object.add_section @symbol_table

      @text = Elf::TextSection.new(".text")
      @object.add_section @text

      @object_machine.run_passes
      assembler = Register::Assembler.new(@object_machine.space)
      set_text assembler.assemble

      # for debug add labels to the block positions
      space.classes.values.each do |clazz|
        clazz.instance_methods.each do |f|
          f.blocks.each do |b|
              add_symbol "#{clazz.name}::#{f.name}@#{b.name}" , b.position
            end
        end
      end
      space.main.blocks.each do |b|
        add_symbol "main@#{b.name}" , b.position
      end
      add_symbol "#register@#{space.init.name}" , space.init.position
      assembler.objects.values.each do |slot|
        label = "#{slot.class.name}::#{slot.position.to_s(16)}"
        label += "=#{slot}" if slot.is_a?(Symbol) or slot.is_a?(String)
        label += "=#{slot.string}" if slot.is_a?(Parfait::Word)
        add_symbol  label , slot.position
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
