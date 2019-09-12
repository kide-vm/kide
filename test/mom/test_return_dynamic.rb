require_relative "helper"

module Risc
  class TestReturnDynamic < MiniTest::Test
    include Statements

    def setup
      @preload = "Integer.div4"
      @input = "return @nil_object.div4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #5
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, Label, LoadConstant, OperatorInstruction, IsZero, #20
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch, #25
                 Label, LoadConstant, SlotToReg, Transfer, Syscall, #30
                 Transfer, Transfer, SlotToReg, RegToSlot, Label, #35
                 RegToSlot, Label, LoadConstant, SlotToReg, SlotToReg, #40
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, RegToSlot, #45
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant, #50
                 SlotToReg, DynamicJump, Label, SlotToReg, RegToSlot, #55
                 Branch,] #60
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal Branch , produced.next(55).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
    end
  end
end
