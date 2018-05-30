require_relative "../helper"

module Risc
  class InterpreterAssignReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 + 5 ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, Branch, FunctionCall, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             RegToSlot, SlotToReg, Branch, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, Branch, FunctionReturn, Transfer, Syscall,
             NilClass]
      assert_equal 10 , get_return.value
    end
  end
end
