require_relative 'helper'

module Methods
  class TestCallSimple < MethodsTest

    def test_call
      run_space <<HERE
      def called( n )
        return n
      end
      def main(arg)
        return called(8)
      end
HERE
      assert_equal Parfait::Integer , get_return.class
      assert_equal 8 , get_return.value
    end
  end
end
