require_relative 'helper'

module Melon
  class TestManyCalls < MiniTest::Test
    include MelonTests

    def pest_ruby_calls_looping
      @string_input = <<HERE

      def fibo_r( n )
         if( n <  2 )
            return n
         else
            return fibo_r(n - 1) + fibo_r(n - 2)
         end
      end

      counter = 1000

      while(counter > 0) do
        fibo_r(20)
        counter -= 1
      end
HERE
      @length = 37
      @stdout = ""
      check
    end
  end
end
