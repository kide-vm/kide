require_relative 'helper'

module Register
  class TestWhile < MiniTest::Test
    include Statements


    def test_while_mini
      @input = s(:statements, s(:while_statement, :plus, s(:conditional, s(:int, 1)), s(:statements, s(:return, s(:int, 3)))))

      @expect = [Label, Branch, Label, LoadConstant, RegToSlot, Label, LoadConstant ,
               IsPlus, Label, FunctionReturn]
      check
    end

    def test_while_assign
      Register.machine.space.get_main.add_local(:n , :Integer)

      @input    = s(:statements, s(:assignment, s(:name, :n), s(:int, 5)), s(:while_statement, :plus, s(:conditional, s(:name, :n)), s(:statements, s(:assignment, s(:name, :n), s(:operator_value, :-, s(:name, :n), s(:int, 1))))), s(:return, s(:name, :n)))

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, Branch, Label, SlotToReg ,
               SlotToReg, LoadConstant, OperatorInstruction, SlotToReg, RegToSlot, Label, SlotToReg ,
               SlotToReg, IsPlus, SlotToReg, SlotToReg, RegToSlot, Label, FunctionReturn]
      check
    end


    def test_while_return
      Register.machine.space.get_main.add_local(:n , :Integer)

      @input    = s(:statements, s(:assignment, s(:name, :n), s(:int, 10)), s(:while_statement, :plus, s(:conditional, s(:operator_value, :-, s(:name, :n), s(:int, 5))), s(:statements, s(:assignment, s(:name, :n), s(:operator_value, :+, s(:name, :n), s(:int, 1))), s(:return, s(:name, :n)))))

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, Branch, Label, SlotToReg ,
               SlotToReg, LoadConstant, OperatorInstruction, SlotToReg, RegToSlot, SlotToReg, SlotToReg ,
               RegToSlot, Label, SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsPlus ,
               Label, FunctionReturn]
      check
    end
  end
end
