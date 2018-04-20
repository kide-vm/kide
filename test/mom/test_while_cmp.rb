require_relative "helper"

module Risc
  class TestWhileCmp < MiniTest::Test
    include Statements

    def setup
      super
      @input = "while(5 > 0) ; @a = true; end"
      @expect = [Label, LoadConstant, LoadConstant, SlotToReg, RegToSlot,
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
                 SlotToReg, RegToSlot, SlotToReg, RegToSlot, SlotToReg,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
                 RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label,
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
                 LoadConstant, OperatorInstruction, IsZero, LoadConstant, OperatorInstruction,
                 IsZero, LoadConstant, SlotToReg, RegToSlot, Branch,
                 Label]
    end

    def test_while_instructions
      assert_nil msg = check_nil , msg
    end
    def test_label
      assert_equal Risc::Label , produce_body.class
    end
    def test_int_load_5
      produced = produce_body
      load = produced.next(16)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 5 , load.constant.value
    end
    def test_int_load_0
      produced = produce_body
      load = produced.next(19)
      assert_equal Risc::LoadConstant , load.class
      assert_equal Parfait::Integer , load.constant.class
      assert_equal 0 , load.constant.value
    end
    def test_false_check
      produced = produce_body
      assert_equal  Risc::IsZero , produced.next(37).class
      assert produced.next(37).label.name.start_with?("merge_label") , produced.next(37).label.name
    end
    def test_nil_load
      produced = produce_body
      assert_equal Risc::LoadConstant , produced.next(38).class
      assert_equal Parfait::NilClass , produced.next(38).constant.class
    end
    def pest_nil_check
      produced = produce_body
      assert_equal produced.next(13) , produced.next(8).label
    end

    def test_back_jump # should jump back to condition label
      produced = produce_body
      assert_equal Risc::Branch , produced.next(44).class
      assert_equal produced , produced.next(44).label
    end

    def test_merge_label
      produced = produce_body
      assert_equal Risc::Label ,  produced.next(45).class
      assert produced.next(45).name.start_with?("merge_") , produced.next(29).name
    end

  end
end
