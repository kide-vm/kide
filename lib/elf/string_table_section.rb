module Elf
  class StringTableSection < Section
    def initialize(*args)
      super

      @string_data = "\x00"
      @indices = {"" => 0}
    end

    def add_string(str)
      return if @indices[str]

      @indices[str] = @string_data.length
      @string_data << str << "\x00"
    end

    def index_for(str)
      @indices[str]
    end

    def write(io)
      io << @string_data
    end

    def type
      Elf::Constants::SHT_STRTAB
    end
  end
end
