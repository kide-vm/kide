require_relative "helper"

module Risc
  class TestReturnDynamic < MiniTest::Test
    include Statements

    def setup
      @preload = "Integer.div4"
      @input = "arg = 1 ;return arg.div4"
      @expect = [LoadConstant, RegToSlot, LoadConstant, SlotToReg, SlotToReg, #5
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, Label, LoadConstant, OperatorInstruction, IsZero, #20
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch, #25
                 Label, LoadConstant, SlotToReg, Transfer, Syscall, #30
                 Transfer, Transfer, SlotToReg, RegToSlot, Label, #35
                 RegToSlot, Label, LoadConstant, SlotToReg, SlotToReg, #40
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #45
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, SlotToReg, #50
                 DynamicJump, Label, SlotToReg, RegToSlot, Branch,] #55
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal Branch , produced.next(54).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(7).class
    end
  end
end
