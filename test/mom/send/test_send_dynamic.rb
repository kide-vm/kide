require_relative "../helper"

module Risc
  class TestSendDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@a.div4"
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

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_sys
      produced = produce_body
      assert_equal Syscall , produced.next(29).class
      assert_equal :died , produced.next(29).name
    end
    def test_load_address
      produced = produce_body
      assert_equal LoadConstant , produced.next(26).class
      assert_equal Parfait::Factory , produced.next(26).constant.class
    end
    def test_function_call
      produced = produce_body
      assert_equal DynamicJump , produced.next(51).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
      assert_equal Label , produced.next(36).class
      assert_equal produced.next(36) , produced.next(6).label
    end
  end
end
