require_relative 'helper'

module Register
class TestIfStatement < MiniTest::Test
  include Statements

  def test_if_basicr
    @input = s(:statements, s(:if_statement, :plus, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))), s(:true_statements, s(:return, s(:int, 3))), s(:false_statements, s(:return, s(:int, 4)))))

  @expect =  [Label, LoadConstant,LoadConstant, OperatorInstruction,IsPlus ,
                LoadConstant,RegToSlot,Branch , Label , LoadConstant ,RegToSlot,
                Label,Label,FunctionReturn]
  check
  end


  def test_if_small_minus
    @input = s(:statements, s(:if_statement, :minus, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))), s(:true_statements, s(:return, s(:int, 3))), s(:false_statements, nil)))

  @expect =  [Label, LoadConstant, LoadConstant, OperatorInstruction, IsMinus, Branch, Label ,
               LoadConstant, RegToSlot, Label, Label, FunctionReturn]
  check
  end


  def test_if_small_zero
    @input = s(:statements, s(:if_statement, :zero, s(:condition, s(:operator_value, :-, s(:int, 10), s(:int, 12))), s(:true_statements, s(:return, s(:int, 3))), s(:false_statements, nil)))

  @expect =  [Label, LoadConstant,LoadConstant,OperatorInstruction,IsZero ,
                Branch , Label , LoadConstant ,RegToSlot,
                Label,Label, FunctionReturn]
  check
  end
end
end
