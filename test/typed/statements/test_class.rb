require_relative 'helper'

module Register
class TestClassStatements < MiniTest::Test
  include Statements

  def class_def
    clean_compile s(:statements, s(:class, :Bar, s(:derives, nil), s(:statements, s(:function, :Integer, s(:name, :buh), s(:parameters), s(:statements, s(:return, s(:int, 1))), s(:receiver, :self)))))
  end

  def test_class_defs
    class_def
    @input =s(:statements, s(:return, s(:int, 1)))
    @expect =  [Label, LoadConstant,SetSlot,Label,FunctionReturn]
    check
  end

  def test_class_call
    #FIXME class call
    # class_def
    # @input = s(:statements, s(:return, s(:call, s(:name, :buh), s(:arguments), s(:receiver, s(:class_name, :Bar)))))
    #
    # @expect = [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
    #            SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
    #            GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
    # check
  end

  def test_class_field
    clean_compile s(:statements, s(:class, :Space, s(:derives, nil), s(:statements, s(:class_field, :Integer, :boo2))))

    @input =s(:statements, s(:return, s(:field_access, s(:receiver, s(:name, :self)),
 s(:field,s(:name, :boo2)))))
    @expect =  [Label, GetSlot,GetSlot,SetSlot,Label,FunctionReturn]
    check
  end
end
end
