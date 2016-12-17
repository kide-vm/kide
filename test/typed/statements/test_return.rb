require_relative 'helper'

module Register
class TestReturnStatement < MiniTest::Test
  include Statements

  def test_return_int
    @input = s(:statements, s(:return, s(:int, 5)))
    @expect =  [Label, LoadConstant ,SetSlot,Label,FunctionReturn]
    check
  end

  def test_return_local
    Register.machine.space.get_main.add_local(:runner , :Integer)
    @input = s(:statements, s(:return, s(:name, :runner)))
    @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,FunctionReturn]
    check
  end

  def test_return_local_assign
    Register.machine.space.get_main.add_local(:runner , :Integer)
    @input = s(:statements, s(:assignment, s(:name, :runner), s(:int, 5)), s(:return, s(:name, :runner)))
    @expect =  [Label, LoadConstant,GetSlot,SetSlot,GetSlot,GetSlot ,SetSlot,
                Label,FunctionReturn]
    check
  end

  def test_return_call
    @input =s(:statements, s(:return, s(:call, s(:name, :main), s(:arguments))))
    @expect =  [Label, GetSlot, GetSlot, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
    check
  end

  def pest_return_space_length # need to add runtime first
    Register.machine.space.get_main.add_local(:l , :Type)
    @input = s(:statements, s(:assignment, s(:name, :l), s(:call, s(:name, :get_type), s(:arguments), s(:receiver, s(:name, :space)))), s(:return, s(:field_access, s(:receiver, s(:name, :self)), s(:field, s(:name, :runner)))))
    @expect =  [Label, GetSlot,GetSlot ,SetSlot,Label,FunctionReturn]
    check
  end

end
end
