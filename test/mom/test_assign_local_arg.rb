require_relative 'helper'

module Risc
  class TestAssignLocalArg < MiniTest::Test
    include Statements

    def setup
      super
      @input = "local = arg"
      @expect = [SlotToReg, SlotToReg, RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_slot_move
      produced = produce_body
      assert_equal produced.next.next.register , produced.register
    end

  end
end
