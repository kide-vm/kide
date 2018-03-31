require_relative "helper"

module Risc
  class TestIfNoElse < MiniTest::Test
    include Statements

    def setup
      super
      @input = "if(@a) ; arg = 5 ; end"
      @expect = [SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsNotZero ,
                 LoadConstant, OperatorInstruction, IsNotZero, Label, LoadConstant ,
                 SlotToReg, RegToSlot, Label]
    end

    def test_if_instructions
      assert_nil msg = check_nil , msg
    end

    def test_false_load
      produced = produce_body
      assert_equal Parfait::FalseClass , produced.next(2).constant.class
    end
    def test_isnotzero
      produced = produce_body
      assert_equal IsNotZero , produced.next(4).class
      assert produced.next(4).label.name.start_with?("false_label")
    end
    def test_false_label
      produced = produce_body
      assert_equal Label , produced.next(12).class
    end
    def test_false_check
      produced = produce_body
      assert_equal produced.next(12) , produced.next(4).label
    end
    def test_nil_load
      produced = produce_body
      assert_equal Parfait::NilClass , produced.next(5).constant.class
    end
    def test_nil_check
      produced = produce_body
      assert_equal Label , produced.next(4).label.class
      assert_equal produced.next(12) , produced.next(4).label
    end
    def test_true_label
      produced = produce_body
      assert produced.next(8).name.start_with?("true_label")
    end

  end
end
