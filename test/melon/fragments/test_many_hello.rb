require_relative 'helper'

module Melon
  class TestManyHello < MiniTest::Test
    include MelonTests

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
