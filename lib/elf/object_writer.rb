require_relative "stream_writer"
require_relative 'object_file'
require_relative 'symbol_table_section'
require_relative 'text_section'
require_relative 'string_table_section'

module Elf

  class ObjectWriter
    def initialize(target = Elf::Constants::TARGET_ARM )
      @object = Elf::ObjectFile.new(target)
      sym_strtab = Elf::StringTableSection.new(".strtab")
      @object.add_section sym_strtab
      @symbol_table = Elf::SymbolTableSection.new(".symtab", sym_strtab)
      @object.add_section @symbol_table

      @text = Elf::TextSection.new(".text")
      @object.add_section @text

      assembler = Register::Assembler.new(Register.machine)
      set_text assembler.write_as_string

      # for debug add labels to the block positions
      Register.machine.space.classes.values.each do |clazz|
        clazz.instance_methods.each do |f|
          f.instructions.each_label do |label|
              add_symbol "#{clazz.name}::#{f.name}:#{label.name}" , label.position
            end
        end
      end

      Register.machine.objects.each do |id,slot|
        next if slot.is_a?(Parfait::BinaryCode)
        if( slot.respond_to? :sof_reference_name )
          label = "#{slot.sof_reference_name}"
        else
          label = "#{slot.class.name}::#{slot.position.to_s(16)}"
        end
        label += "=#{slot}" if slot.is_a?(Symbol) or slot.is_a?(String)
        add_symbol  label , slot.position
        if slot.is_a?(Parfait::Method)
          add_symbol  slot.name.to_s , slot.binary.position
        end
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
