require_relative "../helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 25.div10")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
            SlotToReg, FunctionCall, LoadConstant, SlotToReg, LoadConstant, # 20
            OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg,
            Branch, SlotToReg, Transfer, Transfer, LoadData, # 30
            OperatorInstruction, LoadData, OperatorInstruction, OperatorInstruction, LoadData,
            Transfer, OperatorInstruction, OperatorInstruction, LoadData, Branch, # 40
            Transfer, OperatorInstruction, OperatorInstruction, LoadData, Transfer,
            OperatorInstruction, OperatorInstruction, LoadData, OperatorInstruction, LoadData, # 50
            Transfer, OperatorInstruction, OperatorInstruction, Branch, Transfer,
            LoadData, OperatorInstruction, LoadData, OperatorInstruction, OperatorInstruction, # 60
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, Branch, RegToSlot, RegToSlot, # 70
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
            SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot, # 80
            Branch, SlotToReg, SlotToReg, RegToSlot, Branch,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 90
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg,
            SlotToReg, Syscall, NilClass, ]
       assert_equal 2 , get_return
    end

    def test_load_25
      load_ins = main_ticks 9
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_load_space
      load_ins = main_ticks 66
      assert_load load_ins, Parfait::Factory
    end
    def test_return_class
      ret = main_ticks(93)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
  end
end
