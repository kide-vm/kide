require_relative 'helper'

module Register
class TestClassStatements < MiniTest::Test
  include Statements

  def class_def
    clean_compile :Bar, :buh, {}, s(:statements, s(:return, s(:int, 1)))
  end

  def test_class_defs
    class_def
    @input =s(:statements, s(:return, s(:int, 1)))
    @expect =  [Label, LoadConstant,RegToSlot,Label,FunctionReturn]
    check
  end

  def test_class_call
    #FIXME class call
    # class_def
    # @input = s(:statements, s(:return, s(:call, s(:name, :buh), s(:arguments), s(:receiver, s(:class_name, :Bar)))))
    #
    # @expect = [Label, SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
    #            RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
    #            SlotToReg, SlotToReg, RegToSlot, Label, FunctionReturn]
    # check
  end

  def test_class_field
    #  clean_compile :Space, s(:class_field, :Integer, :boo2)
    #FIXME class_field handling unclear at the moment
    # @input =s(:statements, s(:return, s(:field_access, s(:receiver, s(:name, :self)),
    #             s(:field,s(:name, :boo2)))))
    # @expect =  [Label, SlotToReg,SlotToReg,RegToSlot,Label,FunctionReturn]
    # check
  end
end
end
