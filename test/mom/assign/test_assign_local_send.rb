require_relative '../helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      @preload = "Integer.div4"
      @input = "r = 5.div4;return"
      @expect = [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, Label, SlotToReg, RegToSlot, LoadConstant, #15
                 RegToSlot, Branch,] #20
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      load = produced.next(3)
      assert_equal LoadConstant , load.class
      assert_equal 5 , load.constant.value
    end
  end
end
