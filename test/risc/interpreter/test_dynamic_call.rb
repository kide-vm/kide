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
            SlotToReg, SlotToReg, SlotToReg, LoadConstant, RegToSlot,
            LoadConstant, LoadConstant, SlotToReg, SlotToReg, LoadConstant, # 20
            OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, IsZero,
            SlotToReg, Branch, LoadConstant, OperatorInstruction, IsZero, # 30
            SlotToReg, OperatorInstruction, IsZero, SlotToReg, Branch,
            LoadConstant, OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, # 40
            IsZero, SlotToReg, Branch, LoadConstant, OperatorInstruction,
            IsZero, SlotToReg, OperatorInstruction, IsZero, SlotToReg, # 50
            Branch, LoadConstant, OperatorInstruction, IsZero, SlotToReg,
            OperatorInstruction, IsZero, SlotToReg, Branch, LoadConstant, # 60
            OperatorInstruction, IsZero, SlotToReg, OperatorInstruction, IsZero,
            RegToSlot, LoadConstant, SlotToReg, LoadConstant, SlotToReg, # 70
            SlotToReg, RegToSlot, RegToSlot, RegToSlot, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 80
            SlotToReg, RegToSlot, SlotToReg, LoadConstant, SlotToReg,
            DynamicJump, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, # 90
            IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
            LoadData, OperatorInstruction, Branch, RegToSlot, RegToSlot, # 100
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg, # 110
            FunctionReturn, SlotToReg, RegToSlot, Branch, Branch,
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, # 120
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, # 130
            NilClass, ]

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
      cal = main_ticks(86)
      assert_equal DynamicJump ,  cal.class
    end
    def test_return
      ret = main_ticks(126)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
    def test_sys
      sys = main_ticks(130)
      assert_equal Syscall ,  sys.class
    end
  end
end
