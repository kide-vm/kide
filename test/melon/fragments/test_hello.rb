require_relative 'helper'

module Melon
  class TestRubyHello < MiniTest::Test
    include MelonTests


    def test_ruby_hello
      @string_input = 'puts "Hello there"'
      assert !check
#      assert_equal "Hello there" , @interpreter.stdout
    end

  end
end
