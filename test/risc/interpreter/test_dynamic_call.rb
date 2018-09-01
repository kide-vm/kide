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
            IsZero, RegToSlot, LoadConstant, Branch, SlotToReg,
            LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot, # 80
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, Branch, SlotToReg, RegToSlot, # 90
            SlotToReg, LoadConstant, SlotToReg, DynamicJump, SlotToReg,
            SlotToReg, LoadData, OperatorInstruction, LoadConstant, SlotToReg, # 100
            SlotToReg, RegToSlot, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg, # 110
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg, # 120
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 130
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer,
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal Fixnum , get_return.class
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
      ret = main_ticks(134)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Fixnum , link.class
    end
    def test_sys
      sys = main_ticks(138)
      assert_equal Syscall ,  sys.class
    end
  end
end
