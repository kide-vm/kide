require_relative "helper"

module Risc
  class TestReturnDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return @a.div4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #4
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg, #9
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #14
                 SlotToReg, Label, LoadConstant, OperatorInstruction, IsZero, #19
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch, #24
                 Label, LoadConstant, SlotToReg, Transfer, Syscall, #29
                 Transfer, Transfer, SlotToReg, RegToSlot, Label, #34
                 RegToSlot, Label, LoadConstant, SlotToReg, LoadConstant, #39
                 SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot, #44
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, RegToSlot, #49
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant, #54
                 SlotToReg, DynamicJump, Label, SlotToReg, RegToSlot, #59
                 Branch] #64
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal Branch , produced.next(60).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
    end
  end
end
