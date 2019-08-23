require_relative "../helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main "return 9.div4"
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain   [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, #15
                 IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #20
                 LoadData, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, #25
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #30
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #35
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #40
                 SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, #45
                 Syscall, NilClass,] #50
       assert_equal 2 , get_return
    end

    def test_op
      op = main_ticks(22)
      assert_equal OperatorInstruction , op.class
      assert_equal :>> , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 2 , @interpreter.get_register(:r2)
      assert_equal 2 , @interpreter.get_register(:r3)
    end
  end
end
