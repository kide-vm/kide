require_relative '../helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5.div4;return"
      @expect =  [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot, #4
                 RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, #9
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #14
                 FunctionCall, Label, SlotToReg, RegToSlot, LoadConstant, #19
                 RegToSlot, Branch] #2
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
