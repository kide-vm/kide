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
        check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, LoadConstant, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, Branch, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             FunctionCall, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, OperatorInstruction, IsMinus, IsZero, LoadConstant,
             Branch, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             Branch, LoadConstant, OperatorInstruction, IsZero, LoadConstant,
             OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, LoadConstant, SlotToReg, Branch,
             RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             OperatorInstruction, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             RegToSlot, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, Branch, RegToSlot, Branch,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
             Branch, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, Branch,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, FunctionCall, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, IsMinus,
             IsZero, LoadConstant, RegToSlot, SlotToReg, Branch,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, Branch, LoadConstant, OperatorInstruction, IsZero,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             Transfer, SlotToReg, SlotToReg, Branch, Syscall,
             NilClass]
       assert_equal 0 , get_return
    end
    def test_exit
      done = main_ticks(200)
      assert_equal Syscall ,  done.class
    end
  end
end
