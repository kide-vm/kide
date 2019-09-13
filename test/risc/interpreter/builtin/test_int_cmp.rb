require_relative "../helper"

# TODO move these to interpreter dir
module Risc
  module Macro
    class IntCmp < Minitest::Test
      include Ticker
      def setup
        @preload = [:le,:ge,:gt,:lt].collect{|op| "Integer.#{op}"}.join(";")
      end

      def test_smaller_true
        run_main_return "4 < 5"
        assert_equal Parfait::TrueClass , get_message_return.class
      end
      def test_smaller_false
        run_main_return "6 < 5"
        assert_equal Parfait::FalseClass , get_message_return.class
      end
      def test_smaller_false_same
        run_main_return "5 < 5"
        assert_equal Parfait::FalseClass , get_message_return.class
      end
      def test_larger_true
        run_main_return "5 > 4"
        assert_equal Parfait::TrueClass , get_message_return.class
      end
      def test_larger_false
        run_main_return "5 > 6"
        assert_equal Parfait::FalseClass , get_message_return.class
      end
      def test_larger_false_same
        run_main_return "5 > 5"
        assert_equal Parfait::FalseClass , get_message_return.class
      end

      def test_smaller_or_true
        run_main_return "4 <= 5"
        assert_equal Parfait::TrueClass , get_message_return.class
      end
      def test_smaller_or_false
        run_main_return "6 <= 5"
        assert_equal Parfait::FalseClass , get_message_return.class
      end
      def test_smaller_or_same
        run_main_return "5 <= 5"
        assert_equal Parfait::TrueClass , get_message_return.class
      end
      def test_larger_or_true
        run_main_return "5 >= 4"
        assert_equal Parfait::TrueClass , get_message_return.class
      end
      def test_larger_or_false
        run_main_return "5 >= 6"
        assert_equal Parfait::FalseClass , get_message_return.class
      end
      def test_larger_or_same
        run_main_return "5 >= 5"
        assert_equal Parfait::TrueClass , get_message_return.class
      end
    end
  end
end
