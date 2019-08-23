require_relative "../helper"

module Risc
  class InterpretGetByte < MiniTest::Test
    include Ticker

    def setup
        @string_input = as_main("return 'Hello'.get_internal_byte(0)")
      super
    end
    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, SlotToReg, #15
                 LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, #20
                 SlotToReg, SlotToReg, SlotToReg, ByteToReg, RegToSlot, #25
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #30
                 Branch, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, #45
                 SlotToReg, SlotToReg, Syscall, NilClass,] #50
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(24)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
