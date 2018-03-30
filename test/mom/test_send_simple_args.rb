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
    def pest_function_call
      produced = produce_body
      assert_equal FunctionCall , produced.next(24).class
      assert_equal :mod4 , produced.next(24).method.name
    end
    def pest_check_continue
      produced = produce_body
      assert produced.next(25).name.start_with?("continue_")
    end
    def pest_load_label
      produced = produce_body
      assert_equal Label , produced.next(19).constant.class
    end
    def pest_load_5
      produced = produce_body
      assert_equal 5 , produced.next(16).constant.value
    end
    def pest_call_reg_setup
      produced = produce_body
      assert_equal produced.next(23).register , produced.next(24).register
    end
    #TODO check the message setup, type and frame moves
  end
end
