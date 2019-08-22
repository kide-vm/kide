require_relative "../helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main "return 9.div4"
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
            FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, # 20
            IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
            LoadData, OperatorInstruction, Branch, RegToSlot, RegToSlot, # 30
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg, # 40
            FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 50
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, Branch,
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, # 60
            NilClass, ]
       assert_equal 2 , get_return
    end

    def test_op
      op = main_ticks(27)
      assert_equal OperatorInstruction , op.class
      assert_equal :>> , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 2 , @interpreter.get_register(:r2)
      assert_equal 2 , @interpreter.get_register(:r3)
    end
  end
end
