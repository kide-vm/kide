require_relative "../helper"

module Risc
  class InterpreterMinusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 6 - 5")
      super
    end

    def test_minus
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, SlotToReg, #15
                 LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, #20
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, #25
                 RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #35
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #40
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #45
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #50
       assert_equal 1 , get_return
    end
    def test_op
      op = main_ticks(25)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 1 , @interpreter.get_register(:r2)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(45)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r3 ,  ret.register.symbol
      assert_equal 26008 ,  @interpreter.get_register(ret.register)
    end
  end
end
