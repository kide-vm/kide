require_relative "helper"

module Risc
  class TestReturnSimple < MiniTest::Test
    include Statements

    def setup
      super
      @input = "return 5"
      @expect = [LoadConstant, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn]
    end

    def test_return_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_return
      produced = produce_body
      assert_equal FunctionReturn , produced.next(8).class
    end
    def test_load_5
      produced = produce_body
      assert_equal 5 , produced.constant.value
    end
  end
end
