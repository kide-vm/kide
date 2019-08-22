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
      check_main_chain   [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 20
            SlotToReg, FunctionCall, SlotToReg, SlotToReg, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, RegToByte, SlotToReg, # 30
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 40
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, Branch, SlotToReg, RegToSlot, # 50
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(29)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
