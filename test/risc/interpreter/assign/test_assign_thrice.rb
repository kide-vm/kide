require_relative "../helper"

module Risc
  class InterpreterAssignThrice < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 ;a = 5 + a ;a = 5 + a ; return a")
      super
    end

    def test_all
      run_all
      assert_equal 15 , get_return
    end

  end
end
