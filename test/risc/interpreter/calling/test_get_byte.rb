require_relative "../helper"

module Risc
  class InterpretGetByte < MiniTest::Test
    include Ticker

    def setup
      @preload = "Word.get_byte"
      @string_input = as_main("return 'Hello'.get_internal_byte(0)")
      super
    end
    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, ByteToReg, #25
                 RegToSlot, RegToSlot, SlotToReg, RegToSlot, Branch, #30
                 SlotToReg, Branch, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(25)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
