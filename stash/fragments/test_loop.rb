require_relative 'helper'

module Rubyx
  class TestRubyLoop < MiniTest::Test
    include RubyxTests

    def pest_ruby_loop
      @string_input = <<HERE
  counter = 100000
  while(counter > 0) do
    counter -=  1
  end
HERE
      @stdout = "Hello there"
      check
    end

  end
end
