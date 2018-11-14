require_relative 'helper'

module Mains
  class TestNew < MiniTest::Test
    include Risc::Ticker

    def setup
      @string_input = as_main("a = 1011 ; while(a>0) ; a = a - 1 ; end ; return a")
      super
    end
    def test_chain # max 1011 iterations on 1014 integers (1024 - 10 reserve)
      run_all
      assert_equal Fixnum , get_return.class , " "
      assert_equal 0 , get_return , " "
    end

  end
end
