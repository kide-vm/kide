require_relative '../helper'

module Risc
  class TestAssignArgConst < MiniTest::Test
    include Statements

    def setup
      super
      @input = "arg = 5"
      @expect = [LoadConstant, SlotToReg, RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      assert_equal 5 , produced.constant.value
    end

    def test_slot_move
      produced = produce_body
      assert_equal produced.next(2).register , produced.register
    end
    def test_load_args_from_message
      produced = produce_body
      assert_equal :r0 , produced.next.array.symbol , produced.next.to_rxf
      assert_equal 8 , produced.next.index , produced.next.to_rxf
    end

  end
end
