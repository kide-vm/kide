module Elf
  class ObjectFile
    include ELF

    def initialize(target)
      @target = target

      @sections = []
      add_section NullSection.new
    end

    def add_section(section)
      @sections << section
      section.index = @sections.length - 1
    end

    def write(io)
      io << "\x7fELF"
      io.write_uint8 @target[0]
      io.write_uint8 @target[1]
      io.write_uint8 EV_CURRENT
      io.write_uint8 @target[2]
      io << "\x00" * 8 # pad

      io.write_uint16 ET_REL
      io.write_uint16 @target[3]
      io.write_uint32 EV_CURRENT
      io.write_uint32 0 # entry point
      io.write_uint32 0 # no program header table
      sh_offset_pos = io.tell
      io.write_uint32 0 # section header table offset
      io.write_uint32 0 # no flags
      io.write_uint16 52 # header length
      io.write_uint16 0 # program header length
      io.write_uint16 0 # program header count
      io.write_uint16 40 # section header length

      shstrtab = StringTableSection.new(".shstrtab")
      @sections << shstrtab
      @sections.each { |section|
        shstrtab.add_string section.name
      }

      io.write_uint16 @sections.length # section header count

      io.write_uint16 @sections.length-1 # section name string table index

      # write sections

      section_data = []
      @sections.each { |section|
        offset = io.tell
        section.write(io)
        size = io.tell - offset
        section_data << {:section => section, :offset => offset,
                         :size => size}
      }

      # write section headers

      sh_offset = io.tell

      section_data.each { |data|
        section, offset, size = data[:section], data[:offset], data[:size]
        # write header first
        io.write_uint32 shstrtab.index_for(section.name)
        io.write_uint32 section.type
        io.write_uint32 section.flags
        io.write_uint32 section.addr
        if (section.type == SHT_NOBITS)
          raise 'SHT_NOBITS not handled yet'
        elsif (section.type == SHT_NULL)
          io.write_uint32 0
          io.write_uint32 0
        else
          io.write_uint32 offset
          io.write_uint32 size
        end
        io.write_uint32 section.link
        io.write_uint32 section.info
        io.write_uint32 section.alignment
        io.write_uint32 section.ent_size
      }

      io.seek sh_offset_pos
      io.write_uint32 sh_offset
    end
  end
end
