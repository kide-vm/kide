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
      check_main_chain  [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot, 
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 20
            SlotToReg, RegToSlot, SlotToReg, FunctionCall, SlotToReg,
            SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, # 30
            SlotToReg, RegToByte, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 40
            SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot,
            Branch, SlotToReg, SlotToReg, Branch, RegToSlot, # 50
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, # 60
            SlotToReg, Syscall, NilClass, ]
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(32)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
