require_relative "../helper"

module Risc
  class TestSendDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@a.div4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg,
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg,
                 SlotToReg, Label, LoadConstant, OperatorInstruction, IsZero,
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
                 Label, Transfer, Syscall, Transfer, Transfer,
                 LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
                 RegToSlot, Label, RegToSlot, Label, LoadConstant,
                 SlotToReg, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
                 RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
                 SlotToReg, LoadConstant, SlotToReg, DynamicJump, Label]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_sys
      produced = produce_body
      assert_equal Syscall , produced.next(27).class
      assert_equal :exit , produced.next(27).name
    end
    def test_load_address
      produced = produce_body
      assert_equal LoadConstant , produced.next(41).class
      assert_equal Parfait::Factory , produced.next(41).constant.class
    end
    def test_function_call
      produced = produce_body
      assert_equal DynamicJump , produced.next(58).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
      assert_equal Label , produced.next(38).class
      assert_equal produced.next(38) , produced.next(6).label
    end
  end
end
