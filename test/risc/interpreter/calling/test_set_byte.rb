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
            SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg, # 30
            SlotToReg, SlotToReg, SlotToReg, RegToByte, RegToSlot,
            SlotToReg, SlotToReg, RegToSlot, Branch, LoadConstant, # 40
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            SlotToReg, FunctionReturn, SlotToReg, SlotToReg, Branch, # 50
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, Branch,
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, # 60
            RegToSlot, RegToSlot, SlotToReg, Branch, SlotToReg,
            SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, # 70
            Syscall, NilClass, ]
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(34)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end

  end
end
