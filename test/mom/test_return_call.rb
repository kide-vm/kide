require_relative "helper"

module Risc
  class TestReturnCall < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return 5.div4"
      @expect =  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, Label, SlotToReg, RegToSlot, Branch,] #15
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body.next(14)
      assert_equal Branch , produced.class
      assert_equal "return_label" , produced.label.name
    end
    def test_load_5
      produced = produce_body.next(3)
      assert_equal LoadConstant , produced.class
      assert_equal 5 , produced.constant.value
    end
  end
end
