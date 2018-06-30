require_relative "helper"

module RubyX
  class TestRubyXCompilerRisc < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def test_to_risc
      code = "class Space ; def main(arg);return arg;end; end"
      risc = ruby_to_risc(code, :interpreter)
      assert_equal Array , risc.class
    end

  end
end
