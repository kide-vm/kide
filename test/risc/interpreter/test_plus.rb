require_relative "helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 + 5")
      super
    end

    def est_add
      show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, FunctionCall,
             Label, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg]
      #assert_equal 10 , get_return
    end

    def est_slot3
      sl = ticks( 49 )
      assert_equal SlotToReg , sl.class
      assert_equal :r2 , sl.array.symbol #load from message
      assert_equal 9 , sl.index
      assert_equal :r3 , sl.register.symbol
    end
    def test_slot2 #load arg from args
      sl = ticks( 48 )
      assert_equal SlotToReg , sl.class
      assert_equal :r2 , sl.array.symbol #load from message
      assert_equal 9 , sl.index
      assert_equal :r3 , sl.register.symbol
    end
    def est_slot1 #load args from message
      sl = ticks( 47 )
      assert_equal SlotToReg , sl.class
      assert_equal :r0 , sl.array.symbol #load from message
      assert_equal 2 , sl.index
      assert_equal :r2 , sl.register.symbol
    end
    def est_load_2
      lod = ticks( 46 )
      assert_equal LoadConstant , lod.class
      assert_equal 5 , lod.constant.value
    end

    def pest_zero
      ticks( 12 )
      assert @interpreter.flags[:zero]
    end
  end
end
