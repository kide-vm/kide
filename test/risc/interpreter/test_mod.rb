require_relative "helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main "return 9.mod4"
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [Label, LoadConstant, LoadConstant, SlotToReg, RegToSlot,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
             Label, SlotToReg, SlotToReg, LoadData, OperatorInstruction,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer,
             Syscall, NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal 2 , get_return.value
    end

    def test_load
      lod = main_ticks(17)
      assert_equal LoadConstant , lod.class
      assert_equal 9 , lod.constant.value
    end
    def test_fix # reduce self to fix
      sl = main_ticks(28)
      assert_equal SlotToReg , sl.class
      assert_equal :r1 , sl.array.symbol
      assert_equal 3 , sl.index
      assert_equal :r1 , sl.register.symbol
      assert_equal 9 , @interpreter.get_register(:r1)
    end

    def test_sys
      sys = main_ticks(56)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end

  end
end
