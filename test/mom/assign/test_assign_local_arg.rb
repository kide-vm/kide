require_relative '../helper'

module Risc
  class TestAssignLocalArg < MiniTest::Test
    include Statements

    def setup
      super
      @input = "local = arg; return local"
      @expect =[ SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #4
                 RegToSlot, Branch] #9

    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_slot_move
      produced = produce_body
      assert_equal produced.next(3).register , produced.register
    end
    def test_load_args_from_message
      produced = produce_body
      assert_equal :r0 , produced.array.symbol , produced.next.to_rxf[0..200]
      assert_equal 9 , produced.index , produced.next.to_rxf[0..200]
    end
    def test_load_frame_from_message
      produced = produce_body
      assert_equal :r3 , produced.next(2).array.symbol , produced.next.to_rxf[0..200]
      assert_equal 3 , produced.next.index , produced.next.to_rxf[0..200]
    end
  end
end
