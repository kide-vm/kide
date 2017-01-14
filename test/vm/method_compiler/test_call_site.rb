require_relative 'helper'
require_relative "test_call_expression"

module Register
  class TestCallStatement < MiniTest::Test
    include Statements

    def test_call_constant_int
      clean_compile :Integer, :puti, {}, s(:statements, s(:return, s(:int, 1)))
      @input = s(:call, s(:name, :puti), s(:arguments), s(:receiver, s(:int, 42)))
      @expect =  [Label, SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label ,
                 RegisterTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end


    def test_call_constant_string
      clean_compile :Word, :putstr,{}, s(:statements, s(:return, s(:int, 1)))

      @input =s(:call, s(:name, :putstr), s(:arguments), s(:receiver, s(:string, "Hello")))
      @expect = [Label, SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant ,
                 SlotToReg, RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label ,
                 RegisterTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_call_local_int
      Parfait.object_space.get_main.add_local(:testi , :Integer)
      clean_compile :Integer, :putint, {}, s(:statements, s(:return, s(:int, 1)))
      @input = s(:statements, s(:assignment, s(:name, :testi), s(:int, 20)), s(:call, s(:name, :putint), s(:arguments), s(:receiver, s(:name, :testi))))

      @expect = [Label, LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg ,
                 RegToSlot, LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant ,
                 RegToSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer, SlotToReg, SlotToReg ,
                 LoadConstant, SlotToReg, RegToSlot, Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_call_local_class
      Parfait.object_space.get_main.add_local(:test_l , :List)
      clean_compile :List, :add, {}, s(:statements, s(:return, s(:int, 1)))

      @input =s(:statements, s(:call, s(:name, :add), s(:arguments), s(:receiver, s(:name, :test_l))))
      @expect =  [Label, SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, RegToSlot, RegisterTransfer, FunctionCall ,
                 Label, RegisterTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot ,
                 Label, FunctionReturn]
      assert_nil msg = check_nil , msg
    end

    def test_call_puts
      clean_compile :Space, :putstr, {str: :Word}, s(:statements, s(:return, s(:name, :str)))
      @input =s(:call, s(:name, :putstr), s(:arguments, s(:string, "Hello") ) )
      @expect = [Label, SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot ,
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot ,
                 LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
                 SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot, Label ,
                 FunctionReturn]
      was = check_return
      set = was.next(8)
      assert_equal RegToSlot , set.class
      assert_equal 1, set.index , "Set to message must be offset, not #{set.index}"
    end
  end
end
