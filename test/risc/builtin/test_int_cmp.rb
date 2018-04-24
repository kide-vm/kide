require_relative "helper"

module Risc
  module Builtin
    class IntCmp < BuiltinTest

      def test_smaller_true
        run_main "4 < 5"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_smaller_false
        run_main "6 < 5"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_smaller_false_same
        run_main "5 < 5"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_larger_true
        run_main "5 > 4"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_larger_false
        run_main "5 > 6"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_larger_false_same
        run_main "5 > 5"
        assert_equal Parfait::FalseClass , get_return.class
      end

      def test_smaller_or_true
        run_main "4 <= 5"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_smaller_or_false
        run_main "6 <= 5"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_smaller_or_same
        run_main "5 <= 5"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_larger_or_true
        run_main "5 >= 4"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_larger_or_false
        run_main "5 >= 6"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_larger_or_same
        run_main "5 >= 5"
        assert_equal Parfait::TrueClass , get_return.class
      end
    end
  end
end
