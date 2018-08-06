require_relative "../helper"

module Risc
  class InterpreterWhileCount < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = -1; while( 0 > a); a = 1 + a;end;return a'
      super
    end

    def test_while
      run_all
      assert_equal 0 , get_return
    end
  end
end
