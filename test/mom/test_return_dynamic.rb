require_relative "helper"

module Risc
  class TestReturnDynamic < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return @a.mod4"
      @expect = [LoadConstant, SlotToReg, SlotToReg, SlotToReg, NotSame, SlotToReg ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot ,
                 LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot ,
                 LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant ,
                 FunctionCall, Label, SlotToReg, RegToSlot, Label, LoadConstant ,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg ,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg ,
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, DynamicJump, SlotToReg, SlotToReg ,
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg ,
                 RegToSlot, SlotToReg, Transfer, SlotToReg, FunctionReturn]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal FunctionReturn , produced.next(76).class
    end
    def test_cache_check
      produced = produce_body
      assert_equal NotSame , produced.next(4).class
    end
  end
end
