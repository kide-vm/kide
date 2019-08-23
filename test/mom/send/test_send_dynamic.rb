require_relative "../helper"

module Risc
  class TestSendDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@a.div4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #4
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg, #9
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #14
                 SlotToReg, Label, LoadConstant, OperatorInstruction, IsZero, #19
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch, #24
                 Label, LoadConstant, SlotToReg, Transfer, Syscall, #29
                 Transfer, Transfer, SlotToReg, RegToSlot, Label, #34
                 RegToSlot, Label, LoadConstant, SlotToReg, RegToSlot, #39
                 SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #44
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, SlotToReg, #49
                 DynamicJump, Label, SlotToReg, RegToSlot, Branch,] #54
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_sys
      produced = produce_body
      assert_equal Syscall , produced.next(29).class
      assert_equal :exit , produced.next(29).name
    end
    def test_load_address
      produced = produce_body
      assert_equal LoadConstant , produced.next(26).class
      assert_equal Parfait::Factory , produced.next(26).constant.class
    end
    def test_function_call
      produced = produce_body
      assert_equal DynamicJump , produced.next(50).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
      assert_equal Label , produced.next(36).class
      assert_equal produced.next(36) , produced.next(6).label
    end
  end
end
