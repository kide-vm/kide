require_relative '../helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5.div4;return"
      @expect = [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #4
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #9
                 Label, SlotToReg, RegToSlot, LoadConstant, RegToSlot, #14
                 Branch,] #19
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      load = produced.next(2)
      assert_equal LoadConstant , load.class
      assert_equal 5 , load.constant.value
    end
  end
end
