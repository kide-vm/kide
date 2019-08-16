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
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
            SlotToReg, FunctionCall, LoadConstant, SlotToReg, LoadConstant, # 20
            OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, SlotToReg,
            Branch, SlotToReg, LoadData, OperatorInstruction, RegToSlot, # 30
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, Branch, # 40
            SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot,
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 50
            SlotToReg, RegToSlot, RegToSlot, Branch, SlotToReg,
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, # 60
            SlotToReg, Syscall, NilClass, ]
       assert_equal 2 , get_return
    end

    def test_op
      op = main_ticks(29)
      assert_equal OperatorInstruction , op.class
      assert_equal :>> , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 2 , @interpreter.get_register(:r2)
      assert_equal 2 , @interpreter.get_register(:r3)
    end
  end
end
