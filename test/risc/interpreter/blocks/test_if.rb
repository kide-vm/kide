require_relative "../helper"

module Risc
  module BlockIfOp
    include Ticker
    def setup
      @preload = "Integer.gt;Integer.lt"
      @string_input = block_main("a = tenner {|b| if( b #{op} 5 ); return 1;else;return 2;end } ; return a" , tenner)
      super
    end
    def test_chain
      #show_main_ticks # get output of what is
      run_all
      assert_equal res , get_return , "10 #{op} 5"
    end
  end
  class BlockIfSmall < MiniTest::Test
    include BlockIfOp
    def op
      "<"
    end
    def res
      2
    end
  end
  class BlockIfLarge < MiniTest::Test
    include BlockIfOp
    def op
      ">"
    end
    def res
      1
    end
  end
end
