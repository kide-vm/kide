require_relative "../helper"

module Risc
  class TestSendDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@a.mod4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
                 IsZero, SlotToReg, SlotToReg, LoadConstant, RegToSlot,
                 LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
                 SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
                 Label, SlotToReg, LoadConstant, RegToSlot, Label,
                 LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, DynamicJump]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_call
      produced = produce_body
      assert_equal DynamicJump , produced.next(67).class
    end
    def test_load_address
      produced = produce_body
      assert_equal LoadConstant , produced.next(65).class
      assert_equal Parfait::CacheEntry , produced.next(65).constant.class
    end
    def test_cache_check
      produced = produce_body
      assert_equal IsZero , produced.next(5).class
      assert_equal Label , produced.next(44).class
      assert_equal produced.next(44) , produced.next(5).label
    end
    def test_check_resolve
      produced = produce_body
      assert_equal FunctionCall , produced.next(39).class
      assert_equal :resolve_method ,produced.next(39).method.name
    end
  end
end
