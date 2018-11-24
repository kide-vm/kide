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
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot, # 20
            LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall,
            SlotToReg, SlotToReg, SlotToReg, RegToSlot, SlotToReg, # 30
            SlotToReg, SlotToReg, RegToByte, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot, # 40
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, SlotToReg, Branch, RegToSlot, SlotToReg, # 50
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 60
            SlotToReg, Branch, SlotToReg, SlotToReg, FunctionReturn,
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(33)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
