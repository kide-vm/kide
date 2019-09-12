require_relative '../helper'

module Risc
  class TestAssignLocalIvar < MiniTest::Test
    include Statements

    def setup
      @input = "@nil_object = 5 ; r = @nil_object;return"
      @expect = [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #4
                 RegToSlot, LoadConstant, RegToSlot, Branch] #9
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
