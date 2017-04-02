require_relative 'helper'

module Vool
  class TestIfStatement < MiniTest::Test

    def basic_if
      "if(10 < 12) ; true ; end"
    end

    def test_if_basic
      lst = Compiler.compile( basic_if )
      assert_equal IfStatement , lst.class
    end

    def test_if_basic_cond
      lst = Compiler.compile( basic_if )
      assert_equal SendStatement , lst.condition.class
    end
    def test_if_basic_branches
      lst = Compiler.compile( basic_if )
      assert_equal TrueStatement , lst.if_true.class
      assert_nil lst.if_false
    end

    def pest_if_basicr
      @input = s(:statements, s(:if_statement, :plus, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))), s(:true_statements, s(:return, s(:int, 3))), s(:false_statements, s(:return, s(:int, 4)))))

    @expect =  [Label, LoadConstant, LoadConstant, OperatorInstruction, IsPlus, LoadConstant ,
                 RegToSlot, Branch, Label, LoadConstant, RegToSlot, Label ,
                 LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
    assert_nil msg = check_nil , msg
    end


    def pest_if_small_minus
      @input = s(:statements, s(:if_statement, :minus, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))), s(:true_statements, s(:return, s(:int, 3))), s(:false_statements, nil)))

    @expect = [Label, LoadConstant, LoadConstant, OperatorInstruction, IsMinus, Branch ,
                 Label, LoadConstant, RegToSlot, Label, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
    assert_nil msg = check_nil , msg
    end


    def pest_if_small_zero
      @input = s(:statements, s(:if_statement, :zero, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))), s(:true_statements, s(:return, s(:int, 3))), s(:false_statements, nil)))

    @expect =  [Label, LoadConstant, LoadConstant, OperatorInstruction, IsZero, Branch ,
                 Label, LoadConstant, RegToSlot, Label, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
    assert_nil msg = check_nil , msg
    end
  end
end
