require_relative "helper"

module Mains
  class CompareTester < MiniTest::Test
    include MainsHelper
      def setup
        super
        @preload = [:le,:ge,:gt,:lt].collect{|op| "Integer.#{op}"}.join(";")
      end

      def test_smaller_true
        run_main_return "4 < 5"
        assert_result 1 , ""
      end
      def test_smaller_false
        run_main_return "6 < 5"
        assert_result 0 , ""
      end
      def test_smaller_false_same
        run_main_return "5 < 5"
        assert_result 0 , ""
       end
      def test_larger_true
        run_main_return "5 > 4"
        assert_result 1 , ""
      end
      def test_larger_false
        run_main_return "5 > 6"
        assert_result 0 , ""
      end
      def test_larger_false_same
        run_main_return "5 > 5"
        assert_result 0 , ""
      end
      def test_smaller_or_true
        run_main_return "4 <= 5"
        assert_result 1 , ""
      end
      def test_smaller_or_false
        run_main_return "6 <= 5"
        assert_result 0 , ""
      end
      def test_smaller_or_same
        run_main_return "5 <= 5"
        assert_result 1 , ""
      end
      def test_larger_or_true
        run_main_return "5 >= 4"
        assert_result 1 , ""
      end
      def test_larger_or_false
        run_main_return "5 >= 6"
        assert_result 0 , ""
      end
      def test_larger_or_same
        run_main_return "5 >= 5"
        assert_result 1 , ""
      end
    end
end
