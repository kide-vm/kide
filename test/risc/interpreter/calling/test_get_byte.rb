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
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, FunctionCall, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, ByteToReg, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal "H".ord , get_return.value
    end
    def test_exit
      done = main_ticks(58)
      assert_equal Syscall ,  done.class
    end

    def test_byte_to_reg
      done = main_ticks(32)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end

  end
end
