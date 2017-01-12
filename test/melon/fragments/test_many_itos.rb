require_relative 'helper'

module Melon
  class TestManyItos < MiniTest::Test
    include MelonTests

    def pest_ruby_itos_looping
      @string_input = <<HERE
    counter = 100000

    while(counter > 0) do
    	str = counter.to_s
    	counter = counter - 1
    end
    str
HERE
      @length = 37
      @stdout = "Hello Raisa, I am salama"
      check
    end
  end
end
