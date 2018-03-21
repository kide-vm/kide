require_relative '../helper'

module Risc
  class TestAssignLocalIvar < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@ivar = 5 ; r = @ivar"
      @expect = [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot]
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

  end
end
