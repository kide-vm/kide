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
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #10
                 LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, #15
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, LoadData, #20
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #25
                 RegToSlot, SlotToReg, Branch, SlotToReg, SlotToReg, #30
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #35
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #40
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, #45
                 NilClass,] #50
       assert_equal 2 , get_return
    end

    def test_op
      op = main_ticks(21)
      assert_equal OperatorInstruction , op.class
      assert_equal :>> , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 2 , @interpreter.get_register(:r2)
      assert_equal 2 , @interpreter.get_register(:r3)
    end
  end
end
