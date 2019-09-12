require_relative "helper"

module Risc
  class TestWhileCmp < MiniTest::Test
    include Statements

    def setup
      @preload = "Integer.ge"
      @input = "while(5 > 0) ; @false_object = true; end;return"
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #5
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #10
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #15
                 Label, SlotToReg, LoadConstant, OperatorInstruction, IsZero, #20
                 LoadConstant, OperatorInstruction, IsZero, LoadConstant, SlotToReg, #25
                 RegToSlot, Branch, Label, LoadConstant, RegToSlot, #30
                 Branch,] #35
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end
    def test_label
      assert_equal Risc::Label , produce_body.class
    end
    def test_int_load_5
      produced = produce_body
      load = produced.next(4)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 5 , load.constant.value
    end
    def test_int_load_0
      produced = produce_body
      load = produced.next(7)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 0 , load.constant.value
    end
    def test_false_check
      produced = produce_body
      assert_equal  Risc::IsZero , produced.next(19).class
      assert produced.next(19).label.name.start_with?("merge_label") , produced.next(19).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Risc::LoadConstant , produced.next(23).class
      assert_equal Parfait::TrueClass , produced.next(23).constant.class
    end

    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal Risc::Branch , produced.next(26).class
      assert_equal produced.name , produced.next(26).label.name
    end

  end
end
