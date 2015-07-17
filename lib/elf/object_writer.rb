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

      assembler = Register::Assembler.new(@object_machine)
      set_text assembler.write_as_string

      # for debug add labels to the block positions
      @object_machine.space.classes.values.each do |clazz|
        clazz.instance_methods.each do |f|
          f.source.blocks.each do |b|
              add_symbol "#{clazz.name}::#{f.name}:#{b.name}" , b.position
            end
        end
      end
#      @object_machine.space.main.blocks.each do |b|
#        add_symbol "main@#{b.name}" , b.position
#      end
#      add_symbol "#register@#{@object_machine.space.init.name}" , @object_machine.space.init.position
      @object_machine.objects.each do |slot|
        if( slot.respond_to? :sof_reference_name )
          label = "#{slot.sof_reference_name}"
        else
          label = "#{slot.class.name}::#{slot.position.to_s(16)}"
        end
        label += "=#{slot}" if slot.is_a?(Symbol) or slot.is_a?(String)
        label += "=#{slot.name}" if slot.is_a?(Parfait::BinaryCode)
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
