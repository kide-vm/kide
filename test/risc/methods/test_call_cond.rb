require_relative 'helper'

module Methods
  class TestCallCond < MethodsTest

    def if_cond( arg )
      str = <<HERE
      def called( n )
        if( n < 10)
          return 10
        else
          return 20
        end
      end
      def main(arg)
        return called( ARG )
      end
HERE
      str.sub("ARG" , arg.to_s)
    end
    def test_call_sm
      run_space if_cond(8)
      assert_equal Parfait::Integer , get_return.class
      assert_equal 10 , get_return.value
    end
    def test_call_lg
      run_space if_cond(18)
      assert_equal Parfait::Integer , get_return.class
      assert_equal 20 , get_return.value
    end
  end
end
