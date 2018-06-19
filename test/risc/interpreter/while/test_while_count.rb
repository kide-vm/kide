require_relative "../helper"

module Risc
  class InterpreterWhileCount < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = -1; while( 0 > a); a = 1 + a;end;return a'
      super
    end

    def test_if
        #show_main_ticks # get output of what is in main
        check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, LoadConstant,
             SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, Branch, RegToSlot,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, FunctionCall, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, IsMinus,
             IsZero, LoadConstant, Branch, RegToSlot, SlotToReg,
             Branch, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero,
             Branch, LoadConstant, OperatorInstruction, IsZero, LoadConstant,
             LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, Branch,
             RegToSlot, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, RegToSlot, Branch, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, FunctionCall, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             RegToSlot, SlotToReg, Branch, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, Branch, LoadConstant, LoadConstant,
             SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, Branch, RegToSlot,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, FunctionCall, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, IsMinus,
             IsZero, LoadConstant, RegToSlot, SlotToReg, Branch,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, LoadConstant, OperatorInstruction, IsZero, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             Transfer, SlotToReg, Branch, SlotToReg, Syscall,
             NilClass]
       assert_equal 0 , get_return
    end
    def test_exit
      done = main_ticks(190)
      assert_equal Syscall ,  done.class
    end
  end
end
