require_relative "section"

module Elf
  class NullSection < Section
    def initialize
      super('')
    end

    def write(io)
    end

    def type
      Elf::Constants::SHT_NULL
    end

    def alignment
      0
    end
  end
end
