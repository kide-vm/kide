require_relative "helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main "return 9.mod4"
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot,
             FunctionCall, Label, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             LoadConstant, FunctionCall, Label, SlotToReg, SlotToReg,
             LoadData, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal 2 , get_return.value
    end

    def test_load
      lod = ticks(44)
      assert_equal LoadConstant , lod.class
      assert_equal 9 , lod.constant.value
    end
    def test_fix # reduce self to fix
      sl = ticks(55)
      assert_equal SlotToReg , sl.class
      assert_equal :r1 , sl.array.symbol
      assert_equal 3 , sl.index
      assert_equal :r1 , sl.register.symbol
      assert_equal 9 , @interpreter.get_register(:r1)
    end

    def test_sys
      sys = ticks(83)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end

  end
end
