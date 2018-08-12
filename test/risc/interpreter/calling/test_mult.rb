require_relative "../helper"

module Risc
  class InterpreterMultTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main "return #{2**31} * #{2**31}"
      super
    end

    def test_mult
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, # 20
            FunctionCall, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
            SlotToReg, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg, # 30
            RegToSlot, RegToSlot, RegToSlot, SlotToReg, Branch,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 40
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, # 50
            RegToSlot, Branch, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 60
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer,
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal 0 , get_return
    end
    def test_zero
      ticks( 12 )
      assert @interpreter.flags[:zero]
    end
    def test_op
      op = main_ticks(27)
      assert_equal OperatorInstruction , op.class
      assert_equal :r1 , op.left.symbol
      assert_equal :r2 , op.right.symbol
      assert_equal 0 , @interpreter.get_register(:r1)
      assert_equal 2**31 , @interpreter.get_register(:r2)
    end
    def test_overflow
      main_ticks( 28 )
      assert @interpreter.flags[:overflow]
    end
  end
end
