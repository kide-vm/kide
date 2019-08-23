require_relative "../helper"

module Risc
  class BlockCallSimpleWithArg# < MiniTest::Test
    include Ticker
    def setup
      @string_input = block_main("a = tenner {|b| return b} ; return a" , tenner)
      super
    end
    def test_chain
      run_all
      assert_equal 10 , get_return
    end
  end
  class BlockCallArgOp < MiniTest::Test
    include Ticker
    def setup
      @string_input = block_main("a = tenner {|b| return 2 * b} ; return a" , tenner)
      super
    end
    def test_chain
      run_all
      assert_equal 20 , get_return
    end
  end
end
