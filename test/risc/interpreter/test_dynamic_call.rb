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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, IsZero,
             SlotToReg, SlotToReg, SlotToReg, Branch, LoadConstant,
             RegToSlot, LoadConstant, LoadConstant, SlotToReg, SlotToReg,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             OperatorInstruction, IsZero, Branch, SlotToReg, Branch,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             OperatorInstruction, IsZero, Branch, SlotToReg, Branch,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             OperatorInstruction, IsZero, Branch, SlotToReg, Branch,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             OperatorInstruction, IsZero, Branch, SlotToReg, Branch,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             OperatorInstruction, IsZero, Branch, SlotToReg, Branch,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             OperatorInstruction, IsZero, RegToSlot, Branch, LoadConstant,
             SlotToReg, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, Branch, RegToSlot, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant,
             SlotToReg, Branch, DynamicJump, SlotToReg, SlotToReg,
             LoadData, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, Branch, SlotToReg, SlotToReg, FunctionReturn,
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
      call_ins = main_ticks(4)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end

    def test_dyn
      cal = main_ticks(108)
      assert_equal DynamicJump ,  cal.class
    end
    def test_return
      ret = main_ticks(137)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::Integer , link.class
    end
    def test_sys
      sys = main_ticks(139)
      assert_equal Syscall ,  sys.class
    end
  end
end
