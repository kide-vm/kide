require_relative "helper"

module Risc
  class TestCallSimpleArgs < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.get_internal_word(1)"
      @expect = [LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
                 LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_load_5
      produced = produce_body
      assert_equal 5 , produced.next(16).constant.value
    end
    def test_load_label
      produced = produce_body
      assert_equal LoadConstant , produced.next(23).class
      assert_equal Label , produced.next(23).constant.class
    end
    def test_function_call
      produced = produce_body
      assert_equal FunctionCall , produced.next(28).class
      assert_equal :get_internal_word , produced.next(28).method.name
    end
    def test_call_reg_setup
      produced = produce_body
      assert_equal produced.next(27).register , produced.next(28).register
    end
    def test_check_continue
      produced = produce_body
      assert produced.next(29).name.start_with?("continue_")
    end
    #TODO check the message setup, type and frame moves
  end
end
