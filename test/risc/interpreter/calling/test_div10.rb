require_relative "../helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 25.div10")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
            FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, # 20
            IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
            Transfer, Transfer, Branch, LoadData, OperatorInstruction, # 30
            LoadData, OperatorInstruction, OperatorInstruction, LoadData, Transfer,
            OperatorInstruction, OperatorInstruction, LoadData, Transfer, OperatorInstruction, # 40
            OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction,
            LoadData, OperatorInstruction, LoadData, Transfer, OperatorInstruction, # 50
            OperatorInstruction, Transfer, LoadData, OperatorInstruction, LoadData,
            OperatorInstruction, OperatorInstruction, Branch, RegToSlot, RegToSlot, # 60
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg, # 70
            FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 80
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, Branch,
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, # 90
            NilClass, ]
       assert_equal 2 , get_return
    end

    def test_load_25
      load_ins = main_ticks 9
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_load_space
      load_ins = main_ticks 64
      assert_load load_ins, Parfait::Factory
    end
    def test_return_class
      ret = main_ticks(86)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
  end
end
