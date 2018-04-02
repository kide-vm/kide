require_relative "helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 25.div10")
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
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, LoadData,
             OperatorInstruction, LoadData, OperatorInstruction, OperatorInstruction, LoadData,
             Transfer, OperatorInstruction, OperatorInstruction, LoadData, Transfer,
             OperatorInstruction, OperatorInstruction, LoadData, Transfer, OperatorInstruction,
             OperatorInstruction, LoadData, OperatorInstruction, LoadData, Transfer,
             OperatorInstruction, OperatorInstruction, Transfer, LoadData, OperatorInstruction,
             LoadData, OperatorInstruction, OperatorInstruction, LoadConstant, SlotToReg,
             SlotToReg, RegToSlot, RegToSlot, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal 2 , get_return.value
    end

    def test_call_main
      call_ins = ticks(26)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_25
      load_ins = ticks 44
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return
      ret = ticks(100)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Label , link.class
    end
    def test_sys
      sys = ticks(114)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end
  end
end
