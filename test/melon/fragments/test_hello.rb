require_relative 'helper'

module Melon
  class TestRubyHello < MiniTest::Test
    include MelonTests


    def test_ruby_hello
      @string_input = <<HERE
    puts "Hello there"
HERE
      @stdout = "Hello there"
      check
    end

  end
end
