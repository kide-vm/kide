require_relative 'helper'

module Register
  class TestWhile < MiniTest::Test
    include Statements


    def test_while_mini
      @input = s(:statements,
                s(:while_statement, :plus,
                  s(:conditional,
                    s(:int, 1)),
                  s(:statements,
                    s(:return,
                      s(:int, 3)))))

      @expect = [Label, Branch, Label, LoadConstant, SetSlot, Label, LoadConstant ,
               IsPlus, Label, FunctionReturn]
      check
    end

    def test_while_assign
      @input    = s(:statements,
                    s(:field_def, :Integer,
                      s(:name, :n),
                      s(:int, 5)),
                    s(:while_statement, :plus,
                      s(:conditional,
                        s(:name, :n)),
                      s(:statements,
                        s(:assignment,
                          s(:name, :n),
                          s(:operator_value, :-,
                            s(:name, :n),
                            s(:int, 1))))),
                    s(:return,
                      s(:name, :n)))

      @expect = [Label, LoadConstant, GetSlot, SetSlot, Branch, Label, GetSlot ,
               GetSlot, LoadConstant, OperatorInstruction, GetSlot, SetSlot, Label, GetSlot ,
               GetSlot, IsPlus, GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
      check
    end


    def test_while_return
      @input    =   s(:statements,
                      s(:field_def, :Integer,
                        s(:name, :n),
                        s(:int, 10)),
                      s(:while_statement, :plus,
                        s(:conditional,
                          s(:operator_value, :-,
                            s(:name, :n),
                            s(:int, 5))),
                        s(:statements,
                          s(:assignment,
                            s(:name, :n),
                            s(:operator_value, :+,
                              s(:name, :n),
                              s(:int, 1))),
                          s(:return,
                            s(:name, :n)))))

      @expect = [Label, LoadConstant, GetSlot, SetSlot, Branch, Label, GetSlot ,
               GetSlot, LoadConstant, OperatorInstruction, GetSlot, SetSlot, GetSlot, GetSlot ,
               SetSlot, Label, GetSlot, GetSlot, LoadConstant, OperatorInstruction, IsPlus ,
               Label, FunctionReturn]
      check
    end
  end
end
