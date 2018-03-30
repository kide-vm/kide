require_relative "helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 15 ; return 5 + 5")
      super
    end

    def test_add
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, FunctionCall,
             Label, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg]
      #assert_equal 10 , get_return
    end

    def pest_overflow
      ticks( 12 )
      assert @interpreter.flags[:overflow]
    end

    def pest_zero
      ticks( 12 )
      assert @interpreter.flags[:zero]
    end
  end
end
