require_relative "helper"

module Risc
  class TestReturnDynamic #< MiniTest::Test
    include Statements

    def setup
      super
      @input = "return @a.mod4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
                 IsZero, SlotToReg, SlotToReg, LoadConstant, RegToSlot,
                 LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 RegToSlot, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label,
                 SlotToReg, LoadConstant, RegToSlot, Label, LoadConstant,
                 LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
                 SlotToReg, RegToSlot, SlotToReg, RegToSlot, SlotToReg,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 DynamicJump, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
                 SlotToReg, SlotToReg, FunctionReturn]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal FunctionReturn , produced.next(77).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(5).class
    end
  end
end
