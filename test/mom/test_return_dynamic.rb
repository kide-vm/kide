require_relative "helper"

module Risc
  class TestReturnDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return @a.div4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
                 OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg,
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg,
                 SlotToReg, Label, LoadConstant, SlotToReg, OperatorInstruction,
                 IsZero, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
                 Branch, Label, Transfer, Syscall, Transfer,
                 Transfer, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
                 RegToSlot, RegToSlot, Label, RegToSlot, Label,
                 LoadConstant, SlotToReg, LoadConstant, SlotToReg, RegToSlot,
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
                 SlotToReg, RegToSlot, RegToSlot, SlotToReg, RegToSlot,
                 SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, SlotToReg,
                 DynamicJump, Label, SlotToReg, SlotToReg, RegToSlot,
                 SlotToReg, SlotToReg, RegToSlot, Branch]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal Branch , produced.next(73).class
    end
    def est_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(6).class
    end
  end
end
