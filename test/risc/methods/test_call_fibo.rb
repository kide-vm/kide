require_relative 'helper'

module Methods
  class TestFibo < MethodsTest

    def test_count_down
      run_space <<HERE
      def down( n )
        if( n <  2 )
          return n
        else
          a = down(n - 1)
          return a
        end
      end

      def main(arg)
        return down(8)
      end
HERE
      assert_equal 1 , get_return
    end

    def est_fibo
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
      assert_equal 8 , get_return
    end
  end
end
