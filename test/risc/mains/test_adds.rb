require_relative '../helper'

module Mains
  class TestLargerWhile < MiniTest::Test
    include Risc::Ticker
    def setup;end

    def test_ruby_adds
      run_input <<HERE
        a = 0
        b = 20
        while( a < b )
          a = a + 1
          b = b - 1
        end
        return a
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 10 , get_return.value
    end
    def test_ruby_subs
      run_input <<HERE
        b = 10
        while( b >= 1 )
          b = b - 1
        end
        return b
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 0 , get_return.value
    end
    def test_ruby_adds_fibo
      run_input <<HERE
        n = 6
        a = 0
        b = 1
        i = 1
        while( i < n )
          result = a + b
          a = b
          b = result
          i = i + 1
        end
      	return result
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 8 , get_return.value
    end
  end
end
