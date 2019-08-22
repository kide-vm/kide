require_relative "helper"

module Risc
  class TestWhileSimple < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(@a) ; arg = 5 end;return"
      @expect = [Label, SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, #4
                 IsZero, LoadConstant, OperatorInstruction, IsZero, LoadConstant, #9
                 RegToSlot, Branch, Label, LoadConstant, RegToSlot, #14
                 Branch] #19
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end

    def test_false_load
      produced = produce_body
      assert_equal Parfait::FalseClass , produced.next(3).constant.class
    end
    def test_false_check
      produced = produce_body
      assert_equal IsZero , produced.next(5).class
      assert_equal Label , produced.next(12).class
      assert_equal produced.next(12).name , produced.next(5).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Parfait::NilClass , produced.next(6).constant.class
    end
    def test_merge_label
      produced = produce_body
      assert produced.next(12).name.start_with?("merge_label")
    end
    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal Branch , produced.next(11).class
      assert_equal produced.name , produced.next(11).label.name
    end
  end
end
