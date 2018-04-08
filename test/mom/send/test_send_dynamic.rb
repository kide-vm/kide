require_relative "../helper"

module Risc
  class TestSendDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@a.mod4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
                 IsZero, SlotToReg, SlotToReg, LoadConstant, RegToSlot,
                 LoadConstant, LoadConstant, SlotToReg, SlotToReg, Label,
                 LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
                 OperatorInstruction, IsZero, SlotToReg, Branch, Label,
                 Transfer, Syscall, Transfer, Transfer, LoadConstant,
                 SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot,
                 Label, RegToSlot, Label, LoadConstant, LoadConstant,
                 SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
                 RegToSlot, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, DynamicJump]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_sys
      produced = produce_body
      assert_equal Syscall , produced.next(26).class
      assert_equal :exit , produced.next(26).name
    end
    def test_load_address
      produced = produce_body
      assert_equal LoadConstant , produced.next(38).class
      assert_equal Parfait::CacheEntry , produced.next(38).constant.class
    end
    def test_function_call
      produced = produce_body
      assert_equal DynamicJump , produced.next(59).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(5).class
      assert_equal Label , produced.next(37).class
      assert_equal produced.next(37) , produced.next(5).label
    end
  end
end
