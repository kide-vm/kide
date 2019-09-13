require_relative "../helper"

module Risc
  class InterpreterIfSmallerOr < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.le"
      @string_input = as_main 'if( 5 <= 5 ); return 1;else;return 2;end'
      super
    end

    def test_if
      run_all
      assert_equal 1 , get_return
    end
  end
end
