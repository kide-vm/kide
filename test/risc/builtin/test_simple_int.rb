require_relative "helper"

module Risc
  module Builtin
    class SimpleInt < BuiltinTest

      def test_add
        run_all "5 + 5"
        assert_equal Parfait::Integer , get_return.class
        assert_equal 10 , get_return.value
      end
      def test_minus
        run_all "5 - 5"
        assert_equal 0 , get_return.value
      end
      def test_minus_neg
        run_all "5 - 15"
        assert_equal -10 , get_return.value
      end
      def test_div10
        run_all "45.div10"
        assert_equal 4 , get_return.value
      end
      def test_div4
        run_all "45.div4"
        assert_equal 11 , get_return.value
      end
      def test_mult
        run_all "4 * 4"
        assert_equal 16 , get_return.value
      end
      def test_smaller
        run_all "4 < 5"
        assert_equal 16 , get_return.value
      end
    end
  end
end
