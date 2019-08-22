require_relative "helper"

module Risc
  class TestWhileCmp < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(5 > 0) ; @a = true; end;return"
      @expect =  [Label, LoadConstant, LoadConstant, SlotToReg, SlotToReg, #4
                 RegToSlot, RegToSlot, RegToSlot, RegToSlot, LoadConstant, #9
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #14
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #19
                 Label, SlotToReg, LoadConstant, OperatorInstruction, IsZero, #24
                 LoadConstant, OperatorInstruction, IsZero, LoadConstant, SlotToReg, #29
                 RegToSlot, Branch, Label, LoadConstant, RegToSlot, #34
                 Branch] #39
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
      assert_equal  Risc::IsZero , produced.next(24).class
      assert produced.next(24).label.name.start_with?("merge_label") , produced.next(24).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Risc::LoadConstant , produced.next(28).class
      assert_equal Parfait::TrueClass , produced.next(28).constant.class
    end

    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal Risc::Branch , produced.next(31).class
      assert_equal produced.name , produced.next(31).label.name
    end

  end
end
