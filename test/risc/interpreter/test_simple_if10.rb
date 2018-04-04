require_relative "helper"

module Risc
  class InterpreterSimpleIf10 < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'if( 10 ); return "then";else;return "else";end'
      super
    end

    def test_if
        #show_main_ticks # get output of what is in main
        check_main_chain [Label, LoadConstant, LoadConstant, OperatorInstruction, IsNotZero,
             Label, LoadConstant, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer,
             Syscall, NilClass]
      assert_equal Parfait::Word , get_return.class
      assert_equal "else" , get_return.to_string
    end
    def test_exit
      done = main_ticks(16)
      assert_equal Syscall ,  done.class
    end
  end
end
