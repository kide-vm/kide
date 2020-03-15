require_relative "../helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div10"
      @string_input = as_main("return 25.div10")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, #15
                 IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #20
                 Transfer, Transfer, LoadData, OperatorInstruction, LoadData, #25
                 OperatorInstruction, OperatorInstruction, LoadData, Branch, Transfer, #30
                 OperatorInstruction, OperatorInstruction, LoadData, Transfer, OperatorInstruction, #35
                 OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction, #40
                 LoadData, OperatorInstruction, LoadData, Transfer, OperatorInstruction, #45
                 OperatorInstruction, Transfer, LoadData, OperatorInstruction, LoadData, #50
                 OperatorInstruction, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, #55
                 RegToSlot, Branch, SlotToReg, Branch, SlotToReg, #60
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #65
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #70
                 SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, #75
                 SlotToReg, Transfer, Syscall, NilClass,] #80
       assert_equal 2 , get_return
    end

    def test_load_25
      load_ins = main_ticks 4
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return_class
      ret = risc(73)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
  end
end
