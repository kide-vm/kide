require_relative "helper"

module Risc
  class InterpreterDynamicCall < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div4"
      @string_input = as_main("a = 5 ; return a.div4")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain   [LoadConstant, RegToSlot, LoadConstant, SlotToReg, SlotToReg, #5
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsZero, SlotToReg, #20
                 OperatorInstruction, IsZero, RegToSlot, LoadConstant, SlotToReg, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot, #30
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant, #35
                 SlotToReg, DynamicJump, LoadConstant, SlotToReg, LoadConstant, #40
                 OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg, #45
                 SlotToReg, LoadData, OperatorInstruction, RegToSlot, RegToSlot, #50
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #55
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #60
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #65
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #70
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #75
       assert_equal ::Integer , get_return.class
       assert_equal 1 , get_return
    end

    def test_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert_equal  :main , call_ins.method.name
    end
    def test_load_entry
      call_ins = main_ticks(3)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end

    def test_dyn
      cal = main_ticks(37)
      assert_equal DynamicJump ,  cal.class
    end
    def test_return
      ret = main_ticks(70)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
    def ttest_sys
      sys = main_ticks(112)
      assert_equal Syscall ,  sys.class
    end
  end
end
