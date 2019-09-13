require_relative "../helper"

module Risc
  class BlockCallSimple < MiniTest::Test
    include Ticker
    def setup
      @preload = "Integer.div4"
      @string_input = block_main("a = yielder {return 16.div4} ; return a")
      super
    end
    def test_chain
      run_all
      assert_equal 4 , get_return
    end
  end
end
