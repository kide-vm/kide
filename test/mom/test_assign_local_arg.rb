require_relative 'helper'

module Risc
  class TestAssignLocalArg < MiniTest::Test
    include Statements

    def setup
      super
      @input = "local = arg"
      @expect = [SlotToReg, SlotToReg, SlotToReg, RegToSlot]
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
      assert_equal :r0 , produced.array.symbol , produced.next.to_rxf
      assert_equal 9 , produced.index , produced.next.to_rxf
    end
    def test_load_frame_from_message
      produced = produce_body
      assert_equal :r0 , produced.next(2).array.symbol , produced.next.to_rxf
      assert_equal 2 , produced.next.index , produced.next.to_rxf
    end
  end
end
