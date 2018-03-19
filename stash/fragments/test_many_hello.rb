require_relative 'helper'

module Rubyx
  class TestManyHello < MiniTest::Test
    include RubyxTests

    def pest_ruby_hello_looping
      @string_input = <<HERE
    counter = 100000;
    while(counter > 0) do
    puts "Hello there"
    STDOUT.flush
    counter = counter - 1
    end
HERE
      @length = 37
      @stdout = "Hello there"
      check
    end
  end
end
