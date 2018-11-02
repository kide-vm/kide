require_relative "helper"

module RubyX
  class TestRubyXCompilerBinary < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def setup
#      code = "class Space ; def main(arg);return arg;end; end"
#      @compiler = ruby_to_binary(code, :interpreter)
    end
    def test_to_binary
      code = "class Space ; def main(arg);return arg;end; end"
      @linker = RubyXCompiler.ruby_to_binary(code, :interpreter)
      assert_equal Risc::Linker , @linker.class
    end
    def test_method
    end
  end
end
