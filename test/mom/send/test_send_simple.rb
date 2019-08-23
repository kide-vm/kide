require_relative "../helper"

module Risc
  class TestCallSimple < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.div4"
      @expect = [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #4
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #9
                 Label, SlotToReg, RegToSlot, Branch,] #14
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_5
      produced = produce_body.next(2)
      assert_load( produced , Parfait::Integer)
      assert_equal 5 , produced.constant.value
    end
    def test_load_label
      produced = produce_body.next(5)
      assert_load( produced , Label)
    end
    def test_function_call
      produced = produce_body.next(9)
      assert_equal FunctionCall , produced.class
      assert_equal :div4 , produced.method.name
    end
    def test_check_continue
      produced = produce_body.next(10)
      assert_equal Label , produced.class
      assert produced.name.start_with?("continue_")
    end
    #TODO check the message setup, type and frame moves
  end
end
