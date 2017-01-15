require_relative 'helper'

module Melon
  class TestRubyHello < MiniTest::Test
    include MelonTests


    def test_ruby_hello
      @string_input = in_Space 'def puts(str) ; str.putstring; end ; def main; putstring "Hello there"; end'
      assert !check
      assert_equal "Hello there" , @interpreter.stdout
    end

  end
end
