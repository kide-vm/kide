require_relative "helper"

module Risc
  class InterpretSetByte < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("'Hello'.set_internal_byte(1,75)")
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, FunctionCall,
             Label, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, RegToByte, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn,
             Label, NilClass]
       assert_equal Parfait::Word , get_return.class
       assert_equal "Kello" , get_return.to_string
    end
    def test_reg_to_byte
      done = ticks(68)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end
    def test_exit
      done = ticks(77)
      assert_equal NilClass ,  done.class
    end

  end
end
