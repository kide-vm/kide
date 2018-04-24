require_relative "../helper"

module Risc
  class InterpreterIfSmallerOr < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'if( 5 <= 5 ); return "then";else;return "else";end'
      super
    end

    def test_if
      #show_main_ticks # get output of what is in main
      check_main_chain [Label, LoadConstant, LoadConstant, SlotToReg, RegToSlot,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             OperatorInstruction, IsMinus, LoadConstant, Branch, Label,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero,
             LoadConstant, OperatorInstruction, IsZero, Label, LoadConstant,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, Transfer, Syscall, NilClass]
      assert_equal Parfait::Word , get_return.class
      assert_equal "then" , get_return.to_string
    end
    def test_exit
      done = main_ticks(69)
      assert_equal Syscall ,  done.class
    end
  end
end
