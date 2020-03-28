
require_relative "helper"

module Mains
  class MathsTester < MiniTest::Test
    include MainsHelper

      def test_add
        @preload = "Integer.plus"
        run_main_return "5 + 5"
        assert_result 10 , ""
      end
      def test_minus
        @preload = "Integer.minus"
        run_main_return "5 - 5"
        assert_result 0 , ""
      end
      def test_minus_neg
        @preload = "Integer.minus"
        run_main_return "5 - 15"
#        assert_result( -10 , "")
      end
      def test_rshift
        @preload = "Integer.rs"
        run_main_return "#{2**8} >> 3"
        assert_result 2**5 , ""
      end
      def test_lshift
        @preload = "Integer.ls"
        run_main_return "#{2**8} << 3"
#        assert_result 2**11 , ""
      end
      def test_div10
        @preload = "Integer.div10"
        run_main_return "45.div10"
        assert_result 4 , ""
      end
      def test_div4
        @preload = "Integer.div4"
        run_main_return "45.div4"
        assert_result 11 , ""
      end
      def test_mult
        @preload = "Integer.mul"
        run_main_return "4 * 4"
        assert_result 16 , ""
      end
    end
end
