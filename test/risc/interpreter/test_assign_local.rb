require_relative "helper"

module Risc
  class InterpreterAssignLocal < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 15 ; return a")
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot,
             FunctionCall, Label, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer,
             Syscall, NilClass]
      assert_equal 15 , get_return.value
    end

    def test_call_main
      call_ins = ticks(26)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_15
      load_ins = ticks 28
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::Integer , @interpreter.get_register(load_ins.register).class
      assert_equal 15 , @interpreter.get_register(load_ins.register).value
    end
    def test_transfer
      transfer = ticks(40)
      assert_equal Transfer ,  transfer.class
    end
    def test_sys
      sys = ticks(41)
      assert_equal Syscall ,  sys.class
    end
    def test_return
      ret = ticks(39)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Label , link.class
    end
  end
end
