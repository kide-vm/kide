require_relative 'helper'

module Mains
  class TestNew < MiniTest::Test
    include Risc::Ticker

    def setup
      @string_input = as_main("a = 98 ; while(a>0) ; a = a - 1 ; end ; return a")
      super
    end
    def test_chain # max 98 iterations on 300 integers
      run_all
      assert_equal 0 , get_return , " "
    end

  end
end
