require_relative "../helper"

module Risc
  class TestPuts < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main(" return 'Hello again'.putstring ")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, FunctionCall, SlotToReg,
             SlotToReg, Transfer, Syscall, Transfer, Transfer,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             RegToSlot, SlotToReg, Branch, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, FunctionReturn, SlotToReg, SlotToReg,
             RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal Parfait::Integer , get_return.class
       assert_equal 11 , get_return.value #bytes written
    end
    def test_call
      cal =  main_ticks(24)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(28)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(:r0)
      assert_equal Parfait::Word , @interpreter.get_register(:r1).class
      assert_equal "Hello again" , @interpreter.get_register(:r1).to_string
    end
    def test_move_sys_return
      sl = main_ticks(29)
      assert_equal Transfer , sl.class
      assert_equal :r0 , sl.from.symbol
      assert_equal :r1 , sl.to.symbol
      assert_equal 11 , @interpreter.get_register(:r1)
    end
    def test_restore_message
      sl = main_ticks(30)
      assert_equal Transfer , sl.class
      assert_equal :r8 , sl.from.symbol
      assert_equal :r0 , sl.to.symbol
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_save_sys_return
      sl = main_ticks(35)
      assert_equal RegToSlot , sl.class
      assert_equal :r1 , sl.register.symbol #return
      assert_equal :r2 , sl.array.symbol #parfait integer
      assert_equal  3 , sl.index
    end
    def test_return
      done = main_ticks(43)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
