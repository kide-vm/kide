require_relative "helper"

module RubyX
  class TestRubyXCompilerRisc < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def setup
      super
      code = "class Space ; def main(arg);return arg;end; end"
      @linker = ruby_to_risc(code, :interpreter)
    end
    def test_to_risc
      assert_equal Risc::Linker , @linker.class
    end
    def test_method
      assert_equal :main , @linker.assemblers.first.callable.name
    end
    def test_asm_len
      assert_equal 23 , @linker.assemblers.length
    end
  end
end
