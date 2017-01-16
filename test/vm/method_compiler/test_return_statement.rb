require_relative 'helper'

module Register
  class TestReturnStatement < MiniTest::Test
    include Statements

    def test_return_int
      @input = s(:statements, s(:return, s(:int, 5)))
      @expect =   [Label, LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot ,
                 Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_return_local
      Parfait.object_space.get_main.add_local(:runner , :Integer)
      @input = s(:statements, s(:return, s(:local , :runner)))
      @expect =  [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg ,
                 RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_return_local_assign
      Parfait.object_space.get_main.add_local(:runner , :Integer)
      @input = s(:statements, s(:l_assignment, s(:local, :runner), s(:int, 5)), s(:return, s(:local, :runner)))
      @expect =  [Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_return_call
      @input =s(:statements, s(:return, s(:call, :main, s(:arguments))))
      @expect =  [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, RegToSlot, RegisterTransfer ,
                 FunctionCall, Label, RegisterTransfer, SlotToReg, SlotToReg, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def pest_return_space_length # need to add runtime first
      Parfait.object_space.get_main.add_local(:l , :Type)
      @input = s(:statements, s(:l_assignment, s(:local, :l), s(:call, :get_type, s(:arguments), s(:receiver, s(:known, :space)))), s(:return, s(:field_access, s(:receiver, s(:known, :self)), s(:field, s(:ivar, :runner)))))
      @expect =  [Label, SlotToReg,SlotToReg ,RegToSlot,Label,FunctionReturn]
      assert_nil msg = check_nil , msg
    end

  end
end
