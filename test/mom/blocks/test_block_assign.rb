require_relative "../helper"

module Risc
  class TestBlockAssign < MiniTest::Test
    include Statements

    def setup
      super
      @input = as_block("a = 5")
      @expect =  [LoadConstant, SlotToReg, RegToSlot]
    end
    def test_send_instructions
      assert_nil msg = check_nil(produce_block) , msg
    end
    def test_load_5
      produced = produce_block.next
      assert_load( produced , Parfait::Integer)
      assert_equal 5 , produced.constant.value
    end
  end
end
