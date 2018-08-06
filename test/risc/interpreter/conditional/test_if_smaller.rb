require_relative "../helper"

module Risc
  class InterpreterIfSmaller < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'if( 5 < 5 ); return 1;else;return 2;end'
      super
    end

    def test_if
      run_all
      assert_equal 2 , get_return
    end
  end
end
