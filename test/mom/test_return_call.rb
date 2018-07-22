require_relative "helper"

module Risc
  class TestReturnCall < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return 5.div4"
      @expect = [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 RegToSlot, RegToSlot, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
                 SlotToReg, FunctionCall, Label, SlotToReg, SlotToReg,
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
                 FunctionReturn]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal FunctionReturn , produced.next(35).class
    end
    def test_load_5
      produced = produce_body
      assert_equal LoadConstant , produced.next(14).class
      assert_equal 5 , produced.next(14).constant.value
    end
  end
end
