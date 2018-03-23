require_relative "helper"

module Risc
  class TestReturnCall < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return 5.mod4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant ,
                 FunctionCall, Label, SlotToReg, SlotToReg, RegToSlot, SlotToReg ,
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg ,
                 Transfer, SlotToReg, FunctionReturn]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal FunctionReturn , produced.next(38).class
    end
    def test_load_5
      produced = produce_body
      assert_equal LoadConstant , produced.next(16).class
      assert_equal 5 , produced.next(16).constant.value
    end
  end
end
