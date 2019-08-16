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
      check_main_chain  [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, # 20
            FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction,
            IsNotZero, SlotToReg, RegToSlot, SlotToReg, Branch, # 30
            SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot, # 40
            LoadConstant, SlotToReg, RegToSlot, Branch, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, # 50
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot,
            Branch, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 60
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer,
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal 0 , get_return
    end
    def test_zero
      ticks( 12 )
      assert @interpreter.flags[:zero]
    end
    def test_op
      op = main_ticks(35)
      assert_equal OperatorInstruction , op.class
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 0 , @interpreter.get_register(:r2)
      assert_equal 2**31 , @interpreter.get_register(:r3)
    end
    def test_overflow
      main_ticks( 36 )
      assert @interpreter.flags[:overflow]
    end
  end
end
