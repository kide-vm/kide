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
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, # 20
            SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, # 30
            Branch, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 40
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, # 50
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
            Branch, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 60
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal 1 , get_return
    end
    def test_op
      op = main_ticks(32)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 1 , @interpreter.get_register(:r2)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_return
      ret = main_ticks(60)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r1 ,  ret.register.symbol
      assert_equal 26160 ,  @interpreter.get_register(ret.register)
    end
  end
end
