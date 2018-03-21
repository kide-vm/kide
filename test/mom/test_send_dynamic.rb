require_relative "helper"

module Risc
  class TestSendDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "@a.mod4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, NotSame, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant ,
                 FunctionCall, Label, SlotToReg, RegToSlot, Label, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot ,
                 LoadConstant, SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, DynamicJump]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_call
      produced = produce_body
      assert_equal DynamicJump , produced.next(52).class
    end
    def test_load_address
      produced = produce_body
      assert_equal Parfait::CacheEntry , produced.next(50).constant.class
    end
    def test_cache_check
      produced = produce_body
      assert_equal NotSame , produced.next(3).class
      assert_equal produced.next(34) , produced.next(3).label
    end
    def test_check_resolve
      produced = produce_body
      assert_equal FunctionCall , produced.next(30).class
      assert_equal :resolve_method ,produced.next(30).method.name
    end
  end
end
