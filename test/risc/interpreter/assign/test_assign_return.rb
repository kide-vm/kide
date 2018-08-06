require_relative "../helper"

module Risc
  class InterpreterAssignReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 + 5 ; return a")
      super
    end

    def test_ret
      run_all
      assert_equal 10 , get_return
    end
  end
end
