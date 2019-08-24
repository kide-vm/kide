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
      check_main_chain   [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #30
                 Branch, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #35
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #40
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, #50
                 NilClass,] #55
       assert_equal 1 , get_return
    end
    def test_op
      op = main_ticks(26)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 1 , @interpreter.get_register(:r2)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(46)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r3 ,  ret.register.symbol
      assert_equal 40348 ,  @interpreter.get_register(ret.register)
    end
  end
end
