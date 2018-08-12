require_relative "helper"

module Risc
  class TestReturnCall < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return 5.div4"
      @expect = [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
                 RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
                 FunctionCall, Label, SlotToReg, SlotToReg, RegToSlot,
                 SlotToReg, SlotToReg, RegToSlot, Branch]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body.next(23)
      assert_equal Branch , produced.class
      assert_equal "return_label" , produced.label.name
    end
    def test_load_5
      produced = produce_body.next(8)
      assert_equal LoadConstant , produced.class
      assert_equal 5 , produced.constant.value
    end
  end
end
