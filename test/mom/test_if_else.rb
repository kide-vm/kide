require_relative "helper"

module Risc
  class TestIfElse < MiniTest::Test
    include Statements

    def setup
      super
      @input = "if(@a) ; arg = 5 ; else; arg = 6; end;return"
      @expect =  [SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero, #4
                 LoadConstant, OperatorInstruction, IsZero, Label, LoadConstant, #9
                 RegToSlot, Branch, Label, LoadConstant, RegToSlot, #14
                 Label, LoadConstant, RegToSlot, Branch] #19
    end

    def test_if_instructions
      assert_nil msg = check_nil , msg
    end

    def test_false_load
      produced = produce_body
      assert_equal Parfait::FalseClass , produced.next(2).constant.class
    end
    def test_false_check
      produced = produce_body
      assert_equal IsZero , produced.next(7).class
      assert_equal Label , produced.next(12).class
      assert_equal produced.next(12).name , produced.next(7).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Parfait::NilClass , produced.next(5).constant.class
    end
    def test_nil_check
      produced = produce_body
      assert_equal IsZero , produced.next(4).class
      assert_equal Label , produced.next(12).class
      assert_equal produced.next(12).name , produced.next(4).label.name
    end

    def test_true_label
      produced = produce_body
      assert_equal Label , produced.next(8).class
      assert produced.next(8).name.start_with?("true_label")
    end

    def test_merge_label
      produced = produce_body
      assert_equal Label , produced.next(15).class
      assert produced.next(15).name.start_with?("merge_label")
    end

    def test_true_jump # should jumpp to merge label
      produced = produce_body
      assert_equal Branch , produced.next(11).class
      assert produced.next(11).label.name.start_with?("merge_label")
    end
  end
end
