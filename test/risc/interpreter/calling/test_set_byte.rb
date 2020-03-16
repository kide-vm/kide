require_relative "../helper"

module Risc
  class InterpretSetByte < MiniTest::Test
    include Ticker

    def setup
      @preload = "Word.set_byte"
      @string_input = as_main("return 'Hello'.set_internal_byte(0,75)")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #15
                 SlotToReg, FunctionCall, SlotToReg, RegToSlot, SlotToReg, #20
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToByte, #25
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #30
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, #45
                 SlotToReg, Transfer, Syscall, NilClass,] #50
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(25)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
