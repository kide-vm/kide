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
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, # 20
            FunctionCall, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
            ByteToReg, LoadConstant, SlotToReg, SlotToReg, RegToSlot, # 30
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, Branch,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 40
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
            SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot, # 50
            Branch, Branch, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 60
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg,
            SlotToReg, Syscall, NilClass, ]
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(26)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
