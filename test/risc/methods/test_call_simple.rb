require_relative 'helper'

module Methods
  class TestCallSimple < MethodsTest

    def test_simple
      run_space <<HERE
      def same( n )
        return n
      end
      def main(arg)
        return same(8)
      end
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 8 , get_return.value
    end

    def test_call_with_call
      run_space <<HERE
      def same( n )
        return n
      end
      def main(arg)
        a = same(8 - 1)
        return a
      end
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 7 , get_return.value
    end
  end
end
