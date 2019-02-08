require_relative "helper"

module Elf

  class TestZeroCode < FullTest

    def setup
      super
      @linker = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_risc(as_main("return 1"),:arm)
      @linker.position_all
      @linker.create_binary
    end

    def test_empty_translate
      writer = Elf::ObjectWriter.new(@linker )
      writer.save "test/zero.o"
    end

  end
end
