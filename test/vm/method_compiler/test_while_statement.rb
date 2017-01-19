require_relative 'helper'

module Risc
  class TestWhile < MiniTest::Test
    include Statements


    def test_while_mini
      @input = s(:statements, s(:while_statement, :plus, s(:conditional, s(:int, 1)), s(:statements, s(:return, s(:int, 3)))))

      @expect =  [Label, Branch, Label, LoadConstant, RegToSlot, Label ,
                 LoadConstant, IsPlus, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_while_assign
      Parfait.object_space.get_main.add_local(:n , :Integer)

      @input    = s(:statements, s(:l_assignment, s(:local, :n), s(:int, 5)),
                    s(:while_statement, :plus, s(:conditional, s(:local, :n)),
                      s(:statements, s(:l_assignment, s(:local, :n),
                        s(:operator_value, :-, s(:local, :n), s(:int, 1))))),
                        s(:return, s(:local, :n)))

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, Branch, Label ,
                 SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, SlotToReg, RegToSlot ,
                 Label, SlotToReg, SlotToReg, IsPlus, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end


    def test_while_return
      Parfait.object_space.get_main.add_local(:n , :Integer)

      @input    = s(:statements, s(:l_assignment, s(:local, :n), s(:int, 10)), s(:while_statement, :plus, s(:conditional, s(:operator_value, :-, s(:local, :n), s(:int, 5))),
                    s(:statements, s(:l_assignment, s(:local, :n), s(:operator_value, :+, s(:local, :n), s(:int, 1))),
                            s(:return, s(:local, :n)))))

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, Branch, Label ,
                 SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, SlotToReg, RegToSlot ,
                 SlotToReg, SlotToReg, RegToSlot, Label, SlotToReg, SlotToReg ,
                 LoadConstant, OperatorInstruction, IsPlus, LoadConstant, SlotToReg, RegToSlot ,
                 Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end
  end
end
