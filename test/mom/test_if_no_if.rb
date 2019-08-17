require_relative "helper"

module Risc
  class TestIfNoIf < MiniTest::Test
    include Statements

    def setup
      super
      @input = "unless(@a) ; arg = 5 ; end;return"
      @expect = [SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero, #4
                 LoadConstant, OperatorInstruction, IsZero, Label, Branch, #9
                 Label, LoadConstant, SlotToReg, RegToSlot, Label, LoadConstant, #34
                 RegToSlot, Branch] #14
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
      check = produced.next(4)
      assert_equal IsZero , check.class
      assert check.label.name.start_with?("false_") , check.label.name
    end
    def test_false_label
      produced = produce_body
      assert_equal Label , produced.next(10).class
    end
    def test_false_check
      produced = produce_body
      assert_equal produced.next(10).name , produced.next(4).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Parfait::NilClass , produced.next(5).constant.class
    end
    def est_nil_check
      produced = produce_body
      assert_equal Label , produced.next(4).label.class
      assert_equal produced.next(12) , produced.next(4).label
    end
    def test_true_label
      produced = produce_body
      assert produced.next(8).name.start_with?("true_label")
    end
    def test_merge_label
      produced = produce_body
      assert produced.next(14).name.start_with?("merge_label")
    end

  end
end
