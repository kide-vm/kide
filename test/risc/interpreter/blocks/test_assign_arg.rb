require_relative "../helper"

module Risc
  class BlockAssignArg < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("yielder {arg = 10 ; return 15} ; return arg")
      super
    end

    def test_chain
      run_all
      assert_equal 10 , get_return
    end
  end
  class BlockAssignInst < MiniTest::Test
    include Ticker
    def setup
      @string_input = block_main("yielder {@nil_object = 1 ; return 15} ; return @nil_object")
      super
    end
    def test_chain
      run_all
      assert_equal 1 , get_return
    end
  end
end
