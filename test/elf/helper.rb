require_relative "../helper"

module Elf

  class FullTest < MiniTest::Test
    DEBUG = false

    def setup
    end

    def in_space(input)
      "class Space; #{input} ; end"
    end
    def as_main(input)
      in_space("def main(arg);#{input};end")
    end
    def check(input, file)
      linker = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_binary( input , :arm )
      writer = Elf::ObjectWriter.new(linker)
      writer.save "test/#{file}.o"
    end
  end
end
