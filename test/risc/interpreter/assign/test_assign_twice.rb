require_relative "../helper"

module Risc
  class InterpreterAssignTwice < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("a = 5 ;a = 5 + a ; return a")
      super
    end

    def test_ret
      run_all
      assert_equal 10 , get_return
    end
  end
end
