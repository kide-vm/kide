require_relative "helper"

module Mains
  class WhileTester < MiniTest::Test
    include MainsHelper

    def test_while_cmp
      @preload = "Integer.gt;Integer.plus"
      @input = as_main 'a = -1; while( 0 > a); a = 1 + a;end;return a'
      assert_result  0 , ""
    end

    def test_while_count
      @preload = "Integer.gt;Integer.plus"
      @input = as_main 'a = -1; while( 0 > a); a = 1 + a;end;return a'
      assert_result 0 , ""
    end

    def test_while_simple
      @input = as_main 'a = true; while( a ); a = false;end;return a'
      assert_result 0 , ""
    end

  end
end
