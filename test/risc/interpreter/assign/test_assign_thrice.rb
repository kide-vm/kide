require_relative "../helper"

module Risc
  class InterpreterAssignThrice < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 ;a = 5 + a ;a = 5 + a ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, LoadConstant, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, Branch, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             FunctionCall, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, SlotToReg, Branch,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, Branch, SlotToReg, RegToSlot, LoadConstant,
             LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             Branch, RegToSlot, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, Branch,
             RegToSlot, SlotToReg, FunctionCall, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot,
             SlotToReg, Branch, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, SlotToReg, FunctionReturn, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, Branch,
             SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg,
             SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg,
             SlotToReg, Branch, Syscall, NilClass]
      assert_equal 15 , get_return
    end

  end
end
