require_relative '../helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5.div4"
      @expect = [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 RegToSlot, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, SlotToReg, FunctionCall, Label, SlotToReg,
                 SlotToReg, RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      load = produced.next(15)
      assert_equal LoadConstant , load.class
      assert_equal 5 , load.constant.value
    end
  end
end
