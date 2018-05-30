require_relative "../helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 25.div10")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, FunctionCall, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             LoadData, OperatorInstruction, LoadData, OperatorInstruction, OperatorInstruction,
             LoadData, Transfer, Branch, OperatorInstruction, OperatorInstruction,
             LoadData, Transfer, OperatorInstruction, OperatorInstruction, LoadData,
             Transfer, OperatorInstruction, OperatorInstruction, LoadData, OperatorInstruction,
             LoadData, Branch, Transfer, OperatorInstruction, OperatorInstruction,
             Transfer, LoadData, OperatorInstruction, LoadData, OperatorInstruction,
             OperatorInstruction, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             Branch, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal 2 , get_return.value
    end

    def test_load_25
      load_ins = main_ticks 17
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return
      ret = main_ticks(74)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::Integer , link.class
    end
    def test_sys
      sys = main_ticks(89)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end
  end
end
