require_relative "helper"

module Risc
  class InterpreterDynamicCall < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 ; return a.div4")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, RegToSlot, LoadConstant, SlotToReg, SlotToReg, #5
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg, #10
                 LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsZero, SlotToReg, #20
                 OperatorInstruction, IsZero, SlotToReg, Branch, LoadConstant, #25
                 OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, IsZero, #30
                 SlotToReg, Branch, LoadConstant, OperatorInstruction, IsZero, #35
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch, #40
                 LoadConstant, OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, #45
                 IsZero, SlotToReg, Branch, LoadConstant, OperatorInstruction, #50
                 IsZero, SlotToReg, OperatorInstruction, IsZero, SlotToReg, #55
                 Branch, LoadConstant, OperatorInstruction, IsZero, SlotToReg, #60
                 OperatorInstruction, IsZero, RegToSlot, LoadConstant, SlotToReg, #65
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #70
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, SlotToReg, #75
                 DynamicJump, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, #80
                 IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #85
                 LoadData, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, #90
                 SlotToReg, RegToSlot, SlotToReg, Branch, SlotToReg, #95
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #100
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #105
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #110
                 Syscall, NilClass,] #115

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
      cal = main_ticks(76)
      assert_equal DynamicJump ,  cal.class
    end
    def test_return
      ret = main_ticks(107)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
    def test_sys
      sys = main_ticks(111)
      assert_equal Syscall ,  sys.class
    end
  end
end
