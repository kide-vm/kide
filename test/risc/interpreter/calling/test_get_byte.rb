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
            FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction,
            IsNotZero, SlotToReg, RegToSlot, SlotToReg, Branch, # 30
            SlotToReg, SlotToReg, SlotToReg, ByteToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 40
            SlotToReg, RegToSlot, RegToSlot, Branch, SlotToReg,
            SlotToReg, SlotToReg, FunctionReturn, SlotToReg, SlotToReg, # 50
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, Branch,
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 60
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            SlotToReg, FunctionReturn, Transfer, SlotToReg, SlotToReg, # 70
            Syscall, NilClass, ]
       assert_equal "H".ord , get_return
    end
    def test_byte_to_reg
      done = main_ticks(34)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end
  end
end
