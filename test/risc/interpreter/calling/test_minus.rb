require_relative "../helper"

module Risc
  class InterpreterMinusTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.minus"
      @string_input = as_main("return 6 - 5")
      super
    end

    def test_minus
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal 1 , get_return
    end
    def test_op
      assert_operator 26  , :- , "message.receiver.data_1" , "message.arg1.data_1" , "op_-_"
      assert_equal 1 , @interpreter.get_register(@instruction.result)
      assert_equal 6 , @interpreter.get_register(:"message.receiver.data_1")
      assert_equal 5 , @interpreter.get_register(:"message.arg1.data_1")
    end
    def test_return
      ret = main_ticks(46)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :"message.return_address" ,  ret.register.symbol
      assert_equal 36572 ,  @interpreter.get_register(ret.register).value
    end
  end
end
