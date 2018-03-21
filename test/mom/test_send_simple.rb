require_relative "helper"

module Risc
  class TestCallSimple < MiniTest::Test
    include Statements

    def setup
      super
      @input = "5.mod4"
      @expect = [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg ,
                 FunctionCall, Label]
    end

    def test_send_instructions
      assert_nil msg = check_nil , msg
    end
    def test_function_call
      produced = produce_body
      assert_equal FunctionCall , produced.next(18).class
      assert_equal :mod4 , produced.next(18).method.name
    end
    def test_load_label
      produced = produce_body
      assert_equal Label , produced.next(14).constant.known_object.class
    end
    def test_load_5
      produced = produce_body
      assert_equal 5 , produced.next(11).constant.known_object.value
    end

    def est_call_reg_setup
      produced = produce_body
      assert_equal produced.next(16).register , produced.next(17).register
    end
    def pest_nil_load
      produced = produce_body
      assert_equal Mom::NilConstant , produced.next(4).constant.known_object.class
    end
    def pest_nil_check
      produced = produce_body
      assert_equal produced.next(10) , produced.next(5).label
    end

    def pest_true_label
      produced = produce_body
      assert produced.next(6).name.start_with?("true_label")
    end

  end
end
