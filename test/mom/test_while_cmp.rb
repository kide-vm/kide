require_relative "helper"

module Risc
  class TestWhileCmp < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(5 > 0) ; @a = true; end"
      @expect = [Label, LoadConstant, LoadConstant, SlotToReg, SlotToReg, #4
                 RegToSlot, RegToSlot, RegToSlot, RegToSlot, LoadConstant, #9
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg, #14
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #19
                 FunctionCall, Label, SlotToReg, LoadConstant, OperatorInstruction, #24
                 IsZero, LoadConstant, OperatorInstruction, IsZero, LoadConstant, #29
                 SlotToReg, RegToSlot, Branch, Label] #34
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end
    def test_label
      assert_equal Risc::Label , produce_body.class
    end
    def test_int_load_5
      produced = produce_body
      load = produced.next(9)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 5 , load.constant.value
    end
    def test_int_load_0
      produced = produce_body
      load = produced.next(12)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 0 , load.constant.value
    end
    def test_false_check
      produced = produce_body
      assert_equal  Risc::IsZero , produced.next(25).class
      assert produced.next(25).label.name.start_with?("merge_label") , produced.next(25).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Risc::LoadConstant , produced.next(29).class
      assert_equal Parfait::TrueClass , produced.next(29).constant.class
    end

    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal Risc::Branch , produced.next(32).class
      assert_equal produced.name , produced.next(32).label.name
    end

  end
end
