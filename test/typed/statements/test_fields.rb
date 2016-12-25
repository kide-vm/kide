require_relative 'helper'


module Register
  class TestFieldStatement < MiniTest::Test
    include Statements

    def test_field_named_list
      Register.machine.space.get_main.add_local( :m , :Message)
      @input = s(:statements,  s(:return, s(:field_access,
                                s(:receiver, s(:name, :m)), s(:field, s(:name, :name)))))
      @expect =  [Label, GetSlot, GetSlot, GetSlot, RegToSlot, Label, FunctionReturn]
      check
    end

    def test_field_arg
      Register.machine.space.get_main.add_local( :m , :Message)
      clean_compile :Space, :get_name, { :main => :Message},
                s(:statements, s(:return, s(:field_access,
                    s(:receiver, s(:name, :main)), s(:field, s(:name, :name)))))
      @input =s(:statements, s(:return, s(:call, s(:name, :get_name), s(:arguments, s(:name, :m)))))

      @expect =  [Label, GetSlot, GetSlot, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
                 RegToSlot, GetSlot, GetSlot, RegToSlot, LoadConstant, RegToSlot, RegisterTransfer ,
                 FunctionCall, Label, RegisterTransfer, GetSlot, GetSlot, RegToSlot, Label ,
                 FunctionReturn]
      check
    end

    def test_message_field
      Register.machine.space.get_main.add_local(:name , :Word)
      @input = s(:statements, s(:assignment, s(:name, :name), s(:field_access, s(:receiver, s(:name, :message)), s(:field, s(:name, :name)))), s(:return, s(:name, :name)))

      @expect =   [Label, RegisterTransfer, GetSlot, GetSlot, RegToSlot, GetSlot, GetSlot ,
               RegToSlot, Label, FunctionReturn]
      check
    end
  end
end
