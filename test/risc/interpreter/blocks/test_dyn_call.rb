require_relative "../helper"

module Risc
  class BlockCallDyn < MiniTest::Test
    include Ticker
    def setup
      @string_input = block_main("a = tenner {|b| return b.div4} ; return a" , tenner)
      super
    end
    def test_chain
      #show_main_ticks # get output of what is
      run_all
      assert_equal 2 , get_return , "10.div4"
    end
  end
  class BlockCallArgOpDyn < MiniTest::Test
    include Ticker
    def setup
      @string_input = block_main("a = tenner {|b| return b*b} ; return a" , tenner)
      super
    end
    def test_chain
      run_all
      assert_equal 100 , get_return , "10*10"
    end
  end
end
