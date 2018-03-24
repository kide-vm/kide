require_relative "helper"

module Risc
  class InterpreterReturnCall < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 15.div10")
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
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant,
             FunctionCall, Label, SlotToReg, SlotToReg, SlotToReg,
             LoadConstant, OperatorInstruction, LoadConstant, OperatorInstruction, OperatorInstruction,
             LoadConstant, Transfer, OperatorInstruction, OperatorInstruction, LoadConstant,
             Transfer, OperatorInstruction, OperatorInstruction, LoadConstant, Transfer,
             OperatorInstruction, OperatorInstruction, LoadConstant, OperatorInstruction, LoadConstant,
             Transfer, OperatorInstruction, OperatorInstruction, Transfer, LoadConstant,
             OperatorInstruction, LoadConstant, OperatorInstruction, OperatorInstruction, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, FunctionReturn, Transfer, Syscall,
             NilClass]
      assert_equal 1 , get_return
    end

    def test_call_main
      call_ins = ticks(25)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_15
      load_ins = ticks 43
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 15 , @interpreter.get_register(load_ins.register)
    end
    def test_sys
      sys = ticks(105)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end

    def test_return
      ret = ticks(91)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Label , link.class
    end
  end
end
