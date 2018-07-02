require_relative "helper"

module Elf

  class TestZeroCode < FullTest

    def setup
      super
      @linker = RubyX::RubyXCompiler.new(as_main("return 1")).ruby_to_risc(:arm)
      @linker.position_all
      @linker.create_binary
    end

    def test_empty_translate
      writer = Elf::ObjectWriter.new(@linker )
      writer.save "test/zero.o"
    end

  end
end
