require_relative "helper"

module Risc
  class TestIfNoElse < MiniTest::Test
    include Statements

    def setup
      super
      @input = "if(@a) ; arg = 5 ; end;return"
      @expect =   [SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero, #4
                 LoadConstant, OperatorInstruction, IsZero, Label, LoadConstant, #9
                 RegToSlot, Label, LoadConstant, RegToSlot, Branch] #14
    end

    def test_if_instructions
      assert_nil msg = check_nil , msg
    end
    def test_false_load
      produced = produce_body
      assert_equal Parfait::FalseClass , produced.next(2).constant.class
    end
    def test_isnotzero
      assert_equal IsZero , produce_body.next(4).class
    end
    def test_false_label
      produced = produce_body
      assert_equal Label , produced.next(11).class
    end
    def test_false_check
      produced = produce_body
      assert_equal IsZero , produce_body.next(4).class
      assert_equal Label , produced.next(11).class
      assert_equal produced.next(11).name , produced.next(4).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Parfait::NilClass , produced.next(5).constant.class
    end
    def test_true_label
      produced = produce_body
      assert produced.next(8).name.start_with?("true_label")
    end

  end
end
