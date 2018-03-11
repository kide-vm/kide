require_relative 'helper'


module Risc
  class TestFieldStatement < MiniTest::Test
    include Statements

    def test_field_named_list
      Parfait.object_space.get_main.add_local( :m , :Message)
      @input = s(:statements,  s(:return, s(:field_access,
                                s(:receiver, s(:local, :m)), s(:field, s(:ivar, :name)))))
      @expect = [Label, SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_field_arg
      Parfait.object_space.get_main.add_local( :m , :Message)
      clean_compile :Space, :get_name, { :main => :Message},
                s(:statements, s(:return, s(:field_access,
                    s(:receiver, s(:arg, :main)), s(:field, s(:ivar, :name)))))
      @input =s(:statements, s(:return, s(:call, :get_name, s(:arguments, s(:local, :m)))))

      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, RegToSlot, RiscTransfer, FunctionCall, Label ,
                 RiscTransfer, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_message_field
      Parfait.object_space.get_main.add_local(:name , :Word)
      @input = s(:statements, s(:l_assignment, s(:local, :name), s(:field_access, s(:receiver, s(:known, :message)), s(:field, s(:ivar, :name)))), s(:return, s(:local, :name)))

      @expect = [Label, RiscTransfer, SlotToReg, SlotToReg, RegToSlot, SlotToReg ,
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end
  end
end
