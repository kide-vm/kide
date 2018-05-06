require_relative "stream_writer"
require_relative 'object_file'
require_relative 'symbol_table_section'
require_relative 'text_section'
require_relative 'string_table_section'

module Elf

  class ObjectWriter
    def initialize( machine )
      @machine = machine
      target = Elf::Constants::TARGET_ARM
      @object = Elf::ObjectFile.new(target)
      sym_strtab = Elf::StringTableSection.new(".strtab")
      @object.add_section sym_strtab
      @symbol_table = Elf::SymbolTableSection.new(".symtab", sym_strtab)
      @object.add_section @symbol_table

      @text = Elf::TextSection.new(".text")
      @object.add_section @text

      assembler = Risc::TextWriter.new(@machine)
      set_text assembler.write_as_string

      # for debug add labels for labels
      Parfait.object_space.each_type do |type|
        type.each_method do |f|
          f.cpu_instructions.each do |label|
            next unless label.is_a?(Risc::Label)
            add_symbol "#{type.name}::#{f.name}:#{label.name}" , Risc::Position.get(label).at
          end
        end
      end

      @machine.objects.each do |id,slot|
        next if slot.is_a?(Parfait::BinaryCode)
        if( slot.respond_to? :sof_reference_name )
          label = "#{slot.sof_reference_name}"
        else
          label = "#{slot.class.name}::#{Risc::Position.get(slot)}"
        end
        label += "=#{slot}" if slot.is_a?(Symbol) or slot.is_a?(String)
        add_symbol label , Risc::Position.get(slot).at
        if slot.is_a?(Parfait::TypedMethod)
          add_symbol slot.name.to_s , Risc::Position.get(slot.binary).at
        end
      end
    end

    attr_reader :text

    def set_text(text)
      @text.text = text
      add_symbol "_start", 0
    end

    def add_symbol(name, offset, linkage = Elf::Constants::STB_GLOBAL)
      return add_symbol( name + "_" , offset ) if @symbol_table.has_name(name)
      @symbol_table.add_func_symbol name, offset, @text, linkage
    end

    def save(filename)
      to = File.open(filename, 'wb')
      @object.write to
      to.close
    end

  end
end
