require_relative '../helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5.div4;return"
      @expect = [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
                 RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
                 FunctionCall, Label, SlotToReg, SlotToReg, RegToSlot,
                 LoadConstant, RegToSlot, Branch]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      load = produced.next(8)
      assert_equal LoadConstant , load.class
      assert_equal 5 , load.constant.value
    end
  end
end
