require_relative "../helper"

module Risc
  class InterpreterWhileCmp < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = 0; while( 0 >= a); a = 1 + a;end;return a'
      super
    end

    def test_while
      run_all
      assert_equal 1 , get_return
    end
  end
end
