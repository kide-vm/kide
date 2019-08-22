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
      check_main_chain   [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, # 20
            SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, ByteToReg, # 30
            Branch, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 40
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, # 50
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, Branch,
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, # 60
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(30)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
