require_relative 'helper'
require_relative "test_call_expression"

module Risc
  class TestCallStatement < MiniTest::Test
    include Statements

    def test_call_constant_int
      clean_compile :Integer, :puti, {}, s(:statements, s(:return, s(:int, 1)))
      @input = s(:call, :puti , s(:arguments), s(:receiver, s(:int, 42)))
      @expect =  [Label, SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, RegToSlot, RiscTransfer, FunctionCall, Label ,
                 RiscTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end


    def test_call_constant_string
      clean_compile :Word, :putstr,{}, s(:statements, s(:return, s(:int, 1)))

      @input =s(:call, :putstr, s(:arguments), s(:receiver, s(:string, "Hello")))
      @expect = [Label, SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, RegToSlot, RiscTransfer, FunctionCall, Label ,
                 RiscTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_call_local_int
      Parfait.object_space.get_main.add_local(:testi , :Integer)
      clean_compile :Integer, :putint, {}, s(:statements, s(:return, s(:int, 1)))
      @input = s(:statements, s(:l_assignment, s(:local, :testi), s(:int, 20)), s(:call, :putint, s(:arguments), s(:receiver, s(:local, :testi))))

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant ,
                 RegToSlot, RiscTransfer, FunctionCall, Label, RiscTransfer, SlotToReg, SlotToReg ,
                 LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_call_local_class
      Parfait.object_space.get_main.add_local(:test_l , :List)
      clean_compile :List, :add, {}, s(:statements, s(:return, s(:int, 1)))

      @input =s(:statements, s(:call, :add, s(:arguments), s(:receiver, s(:local, :test_l))))
      @expect =  [Label, SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, RegToSlot, RiscTransfer, FunctionCall ,
                 Label, RiscTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot ,
                 Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_call_puts
      clean_compile :Space, :putstr, {str: :Word}, s(:statements, s(:return, s(:arg, :str)))
      @input =s(:call, :putstr , s(:arguments, s(:string, "Hello") ) )
      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot ,
                 LoadConstant, RegToSlot, RiscTransfer, FunctionCall, Label, RiscTransfer ,
                 SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      was = check_return
      set = was.next(8)
      assert_equal RegToSlot , set.class
      assert_equal 1, set.index , "Set to message must be offset, not #{set.index}"
    end
  end
end
