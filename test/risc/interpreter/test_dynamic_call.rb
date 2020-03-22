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
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, SlotToReg, #5
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsZero, SlotToReg, #20
                 OperatorInstruction, IsZero, RegToSlot, LoadConstant, Branch, #25
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #30
                 RegToSlot, LoadConstant, SlotToReg, LoadConstant, SlotToReg, #35
                 RegToSlot, SlotToReg, DynamicJump, LoadConstant, LoadConstant, #40
                 SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, LoadData, OperatorInstruction, RegToSlot, #50
                 RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg, #55
                 Branch, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #60
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #65
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn, #70
                 Transfer, SlotToReg, SlotToReg, Transfer, Syscall, #75
                 NilClass,] #80
       assert_equal ::Integer , get_return.class
       assert_equal 1 , get_return
    end
    def test_load_entry
      call_ins = main_ticks(3)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end
    def test_dyn
      cal = main_ticks(38)
      assert_equal DynamicJump ,  cal.class
    end
  end
end
