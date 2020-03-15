require_relative "../helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.div4"
      @string_input = as_main "return 9.div4"
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, #15
                 IsNotZero, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #20
                 LoadData, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, #25
                 RegToSlot, Branch, SlotToReg, Branch, SlotToReg, #30
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, #45
                 SlotToReg, Transfer, Syscall, NilClass,] #50
       assert_equal 2 , get_return
    end

    def test_op
      assert_operator 22 , :>>,  "message.receiver.data_1" , "integer_1" , "op_>>_"
      assert_equal 2 , @interpreter.get_register(:integer_1)
      assert_equal 9 , @interpreter.get_register(:"message.receiver.data_1")
    end
  end
end
