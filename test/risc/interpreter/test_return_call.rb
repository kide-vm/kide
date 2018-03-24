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
      check_chain [Branch, Label, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, RegToSlot, FunctionCall, Label,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
             Label, SlotToReg, SlotToReg, SlotToReg, LoadConstant,
             OperatorInstruction, LoadConstant, OperatorInstruction, OperatorInstruction, LoadConstant,
             Transfer, OperatorInstruction, OperatorInstruction, LoadConstant, Transfer,
             OperatorInstruction, OperatorInstruction, LoadConstant, Transfer, OperatorInstruction,
             OperatorInstruction, LoadConstant, OperatorInstruction, LoadConstant, Transfer,
             OperatorInstruction, OperatorInstruction, Transfer, LoadConstant, OperatorInstruction,
             LoadConstant, OperatorInstruction, OperatorInstruction, RegToSlot, Label,
             NilClass]
      assert_equal 1 , get_return
    end

    def ttest_call_main
      call_ins = ticks(9)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def ttest_load_5
      load_ins = ticks 11
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 5 , @interpreter.get_register(load_ins.register).value
    end
    def ttest_transfer
      transfer = ticks(19)
      assert_equal Transfer ,  transfer.class
    end
    def ttest_sys
      sys = ticks(20)
      assert_equal Syscall ,  sys.class
    end
    def ttest_return
      ret = ticks(18)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Label , link.class
    end
  end
end
