require_relative "helper"

module Risc
  class TestIfElse < MiniTest::Test
    include Statements

    def setup
      super
      @input = "if(@a) ; arg = 5 ; else; arg = 6; end"
      @expect = [SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero,
                 LoadConstant, OperatorInstruction, IsZero, Label, LoadConstant,
                 SlotToReg, RegToSlot, Branch, Label, LoadConstant,
                 SlotToReg, RegToSlot, Label]
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
      assert_equal produced.next(13) , produced.next(4).label
    end
    def test_nil_load
      produced = produce_body
      assert_equal Parfait::NilClass , produced.next(5).constant.class
    end
    def test_nil_check
      produced = produce_body
      assert_equal produced.next(13) , produced.next(7).label
    end

    def test_true_label
      produced = produce_body
      assert produced.next(8).name.start_with?("true_label")
    end

    def test_merge_label
      produced = produce_body
      assert produced.next(17).name.start_with?("merge_label")
    end

    def test_true_jump # should jumpp to merge label
      produced = produce_body
      assert produced.next(12).label.name.start_with?("merge_label")
    end
  end
end
