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
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
            SlotToReg, FunctionCall, SlotToReg, SlotToReg, Transfer, # 20
            Syscall, Transfer, Transfer, LoadConstant, SlotToReg,
            SlotToReg, RegToSlot, RegToSlot, RegToSlot, SlotToReg, # 30
            Branch, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg, # 40
            FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, # 50
            RegToSlot, Branch, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 60
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(17)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(21)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(:r0)
      assert_equal Parfait::Word , @interpreter.get_register(:r1).class
      assert_equal "Hello again" , @interpreter.get_register(:r1).to_string
    end
    def test_move_sys_return
      sl = main_ticks(22)
      assert_equal Transfer , sl.class
      assert_equal :r0 , sl.from.symbol
      assert_equal :r3 , sl.to.symbol
      assert_equal 11 , @interpreter.get_register(:r3)
    end
    def test_restore_message
      sl = main_ticks(23)
      assert_equal Transfer , sl.class
      assert_equal :r8 , sl.from.symbol
      assert_equal :r0 , sl.to.symbol
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_save_sys_return
      sl = main_ticks(28)
      assert_equal RegToSlot , sl.class
      assert_equal :r3 , sl.register.symbol #return
      assert_equal :r2 , sl.array.symbol #parfait integer
      assert_equal  2 , sl.index
    end
    def test_return
      done = main_ticks(60)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
