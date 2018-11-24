require_relative "helper"

module Risc
  class TestReturnDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return @a.div4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #5
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, Label, LoadConstant, OperatorInstruction, IsZero, #20
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch, #25
                 Label, LoadConstant, SlotToReg, Transfer, Syscall, #30
                 Transfer, Transfer, SlotToReg, RegToSlot, Label, #35
                 RegToSlot, Label, LoadConstant, SlotToReg, LoadConstant, #40
                 SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot, #45
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, RegToSlot, #50
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant, #55
                 SlotToReg, DynamicJump, Label, SlotToReg, SlotToReg, #60
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, Branch] #65
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal Branch , produced.next(64).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
    end
  end
end
