require_relative 'helper'


module Register
  class TestFieldStatement < MiniTest::Test
    include Statements

    def test_field_named_list
      Parfait.object_space.get_main.add_local( :m , :Message)
      @input = s(:statements,  s(:return, s(:field_access,
                                s(:receiver, s(:name, :m)), s(:field, s(:name, :name)))))
      @expect = [Label, SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_field_arg
      Parfait.object_space.get_main.add_local( :m , :Message)
      clean_compile :Space, :get_name, { :main => :Message},
                s(:statements, s(:return, s(:field_access,
                    s(:receiver, s(:name, :main)), s(:field, s(:name, :name)))))
      @input =s(:statements, s(:return, s(:call, s(:name, :get_name), s(:arguments, s(:name, :m)))))

      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label ,
                 RegisterTransfer, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_message_field
      Parfait.object_space.get_main.add_local(:name , :Word)
      @input = s(:statements, s(:l_assignment, s(:name, :name), s(:field_access, s(:receiver, s(:name, :message)), s(:field, s(:name, :name)))), s(:return, s(:name, :name)))

      @expect = [Label, RegisterTransfer, SlotToReg, SlotToReg, RegToSlot, SlotToReg ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end
  end
end
