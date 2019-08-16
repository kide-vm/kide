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
            SlotToReg, FunctionCall, LoadConstant, SlotToReg, LoadConstant, # 20
            OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, RegToSlot,
            Branch, SlotToReg, SlotToReg, Transfer, Syscall, # 30
            Transfer, Transfer, SlotToReg, RegToSlot, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, Branch, # 40
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, # 50
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, Branch, SlotToReg, SlotToReg, SlotToReg, # 60
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall,
            NilClass, ]
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(17)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(30)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(:r0)
      assert_equal Parfait::Word , @interpreter.get_register(:r1).class
      assert_equal "Hello again" , @interpreter.get_register(:r1).to_string
    end
    def test_move_sys_return
      sl = main_ticks(31)
      assert_transfer(sl, :r0 ,:r3)
      assert_equal 11 , @interpreter.get_register(:r3)
    end
    def test_restore_message
      sl = main_ticks(32)
      assert_transfer(sl, :r8 ,:r0)
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_move_sys_return
      sl = main_ticks(37)
      assert_reg_to_slot( sl , :r1 ,:r2 , 5)
    end
    def test_return
      done = main_ticks(61)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
