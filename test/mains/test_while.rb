require_relative "helper"

module Mains
  class WhileTester < MiniTest::Test
    include MainsHelper

    def test_while
      @preload = "Integer.gt;Integer.plus"
      @input = as_main 'a = -1; while( 0 > a); a = 1 + a;end;return a'
      assert_result  0 , ""
    end
  end
end
