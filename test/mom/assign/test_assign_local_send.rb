require_relative '../helper'

module Risc
  class TestAssignLocalSend < MiniTest::Test
    include Statements

    def setup
      super
      @input = "r = 5.mod4"
      @expect = [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg ,
                 LoadConstant, FunctionCall, Label, SlotToReg, SlotToReg, RegToSlot]
    end
    def test_local_assign_instructions
      assert_nil msg = check_nil , msg
    end

    def test_constant_load
      produced = produce_body
      assert_equal 5 , produced.next(11).constant.value
    end
  end
end
