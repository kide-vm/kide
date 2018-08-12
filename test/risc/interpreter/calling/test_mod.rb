require_relative "../helper"

module Risc
  class InterpreterMod < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main "return 9.div4"
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
            SlotToReg, FunctionCall, SlotToReg, SlotToReg, LoadData, # 20
            OperatorInstruction, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot, # 30
            Branch, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, # 40
            SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
            Branch, SlotToReg, SlotToReg, RegToSlot, Branch, # 50
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, # 60
            SlotToReg, Syscall, NilClass, ]
       assert_equal 2 , get_return
    end

    def test_load
      lod = main_ticks(9)
      assert_equal LoadConstant , lod.class
      assert_equal 9 , lod.constant.value
    end
    def test_fix # reduce self to fix
      sl = main_ticks(19)
      assert_equal SlotToReg , sl.class
      assert_equal :r1 , sl.array.symbol
      assert_equal 2 , sl.index
      assert_equal :r1 , sl.register.symbol
      assert_equal 9 , @interpreter.get_register(:r1)
    end

  end
end
