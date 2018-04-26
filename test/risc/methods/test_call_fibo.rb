require_relative 'helper'

module Methods
  class TestFibo < MethodsTest

    def est_ruby_adds
      run_space <<HERE
      def fibo_r( n )
        if( n <  2 )
          return n
        else
          a = fibo_r(n - 1)
          b = fibo_r(n - 2)
          return a + b
        end
      end

      def main(arg)
        return fibo_r(8)
      end
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 8 , get_return.value
    end
  end
end
