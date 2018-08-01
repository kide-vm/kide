require_relative "../helper"

module Risc
  class BlockWhile < MiniTest::Test
    include Ticker
    def setup
      @string_input = block_main("a = tenner {|b| #{while_str} } ; return a" , tenner)
      super
    end
    def while_str
      "while( b > 5); b = b - 1 ;end;return b"
    end
    def test_chain
      #show_main_ticks # get output of what is
      run_all
      assert_equal 5 , get_return , while_str
    end
  end
end
