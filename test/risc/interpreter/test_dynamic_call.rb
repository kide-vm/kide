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
      check_main_chain [Label, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
             IsZero, SlotToReg, SlotToReg, SlotToReg, LoadConstant,
             RegToSlot, LoadConstant, LoadConstant, SlotToReg, SlotToReg,
             Label, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
             SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
             Label, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
             SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
             Label, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
             SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
             Label, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
             SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
             Label, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
             SlotToReg, OperatorInstruction, IsZero, Label, RegToSlot,
             Label, LoadConstant, SlotToReg, LoadConstant, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             LoadConstant, SlotToReg, DynamicJump, Label, SlotToReg,
             SlotToReg, LoadData, OperatorInstruction, LoadConstant, SlotToReg,
             SlotToReg, RegToSlot, RegToSlot, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal 1 , get_return.value
    end

    def test_call_main
      call_ins = ticks(26)
      assert_equal FunctionCall , call_ins.class
      assert_equal  :main , call_ins.method.name
    end
    def test_load_entry
      call_ins = main_ticks(5)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end

    def test_dyn
      cal = main_ticks(98)
      assert_equal DynamicJump ,  cal.class
    end
    #should end in exit, but doesn't, becasue resolve never returns
    def test_sys
      sys = main_ticks(129)
      assert_equal Syscall ,  sys.class
    end
    def test_return
      ret = main_ticks(127)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Label , link.class
    end
  end
end
