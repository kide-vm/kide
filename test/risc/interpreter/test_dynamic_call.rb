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
            SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, IsZero, # 10
            SlotToReg, SlotToReg, SlotToReg, Branch, LoadConstant,
            RegToSlot, LoadConstant, LoadConstant, SlotToReg, SlotToReg, # 20
            LoadConstant, OperatorInstruction, IsZero, SlotToReg, OperatorInstruction,
            IsZero, SlotToReg, Branch, Branch, LoadConstant, # 30
            OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, IsZero,
            SlotToReg, Branch, Branch, LoadConstant, OperatorInstruction, # 40
            IsZero, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
            Branch, Branch, LoadConstant, OperatorInstruction, IsZero, # 50
            SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
            Branch, LoadConstant, OperatorInstruction, IsZero, SlotToReg, # 60
            OperatorInstruction, IsZero, SlotToReg, Branch, Branch,
            LoadConstant, OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, # 70
            IsZero, RegToSlot, LoadConstant, SlotToReg, LoadConstant,
            Branch, SlotToReg, SlotToReg, RegToSlot, RegToSlot, # 80
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, Branch, # 90
            SlotToReg, LoadConstant, SlotToReg, DynamicJump, LoadConstant,
            SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, # 100
            RegToSlot, SlotToReg, Branch, SlotToReg, LoadData,
            OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, SlotToReg, # 110
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
            SlotToReg, Branch, SlotToReg, SlotToReg, FunctionReturn, # 120
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, Branch, # 130
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]# 140
       assert_equal ::Integer , get_return.class
       assert_equal 1 , get_return
    end

    def test_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert_equal  :main , call_ins.method.name
    end
    def test_load_entry
      call_ins = main_ticks(4)
      assert_equal LoadConstant , call_ins.class
      assert_equal  Parfait::CacheEntry , call_ins.constant.class
    end

    def test_dyn
      cal = main_ticks(94)
      assert_equal DynamicJump ,  cal.class
    end
    def test_return
      ret = main_ticks(135)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
    def test_sys
      sys = main_ticks(139)
      assert_equal Syscall ,  sys.class
    end
  end
end
