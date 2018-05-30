require_relative "../helper"

module Risc
  class InterpreterAssignLocal < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 15 ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, SlotToReg, FunctionReturn, Transfer, Syscall,
             NilClass]
      assert_equal 15 , get_return.value
    end

    def test_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_15
      load_ins = main_ticks(1)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::Integer , @interpreter.get_register(load_ins.register).class
      assert_equal 15 , @interpreter.get_register(load_ins.register).value
    end
    def test_return
      ret = main_ticks(13)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Fixnum , link.class
    end
    def test_transfer
      transfer = main_ticks(14)
      assert_equal Transfer ,  transfer.class
    end
    def test_sys
      sys = main_ticks(15)
      assert_equal Syscall ,  sys.class
    end
  end
end
