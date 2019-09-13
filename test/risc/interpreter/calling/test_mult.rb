require_relative "../helper"

module Risc
  class InterpreterMultTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.mul"
      @string_input = as_main "return #{2**31} * #{2**31}"
      super
    end

    def test_mult
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, Branch, SlotToReg, SlotToReg, RegToSlot, #35
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #40
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Syscall, NilClass,] #55
       assert_equal 0 , get_return
    end
    def test_zero
      ticks( 12 )
      assert @interpreter.flags[:zero]
    end
    def test_op
      op = main_ticks(26)
      assert_equal OperatorInstruction , op.class
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 0 , @interpreter.get_register(:r2)
      assert_equal 2**31 , @interpreter.get_register(:r3)
    end
    def test_overflow
      main_ticks( 26 )
      assert @interpreter.flags[:overflow]
    end
  end
end
