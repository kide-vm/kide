require_relative "../helper"

module Risc
  class InterpreterIfGreaterOr < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'if( 5 >= 5 ); return 1;else;return 2;end'
      super
    end

    def test_if
      #show_main_ticks # get output of what is in main
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, Branch, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, FunctionCall, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, OperatorInstruction, IsMinus, LoadConstant,
             Branch, RegToSlot, SlotToReg, SlotToReg, Branch,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             LoadConstant, OperatorInstruction, IsZero, LoadConstant, OperatorInstruction,
             IsZero, LoadConstant, RegToSlot, Branch, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, SlotToReg, SlotToReg, Branch,
             Syscall, NilClass]
      assert_equal 1 , get_return
    end
    def test_exit
      done = main_ticks(71)
      assert_equal Syscall ,  done.class
    end
  end
end
