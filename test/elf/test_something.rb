require_relative "helper"

module Elf
  class SomethingTest < FullTest

    def test_add
      input = <<HERE
      def fibo( n)
      	 a = 0
      	 b = 1
      	 i = 1
        while( i < n ) do
          result = a + b
          a = b
          b = result
          i += 1
        end
      	return result
      end
      def main(arg)
        return fibo(20)
      end
HERE
      @exit_code = 4
      check in_space(input) , "fibo"
    end
  end
end
