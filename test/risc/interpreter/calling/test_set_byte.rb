require_relative "../helper"

module Risc
  class InterpretSetByte < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 'Hello'.set_internal_byte(0,75)")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain   [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #15
                 FunctionCall, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #20
                 SlotToReg, SlotToReg, RegToByte, SlotToReg, SlotToReg, #25
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #30
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #35
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #40
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #45
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(23)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
