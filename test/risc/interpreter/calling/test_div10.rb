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
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #10
                 LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, #15
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, Transfer, #20
                 Transfer, LoadData, OperatorInstruction, LoadData, OperatorInstruction, #25
                 OperatorInstruction, LoadData, Branch, Transfer, OperatorInstruction, #30
                 OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction, #35
                 LoadData, Transfer, OperatorInstruction, OperatorInstruction, LoadData, #40
                 OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction, #45
                 Transfer, LoadData, OperatorInstruction, LoadData, OperatorInstruction, #50
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #55
                 RegToSlot, SlotToReg, Branch, SlotToReg, SlotToReg, #60
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #65
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #70
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, #75
                 NilClass,] #80s
       assert_equal 2 , get_return
    end

    def test_load_25
      load_ins = main_ticks 3
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return_class
      ret = main_ticks(71)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
  end
end
