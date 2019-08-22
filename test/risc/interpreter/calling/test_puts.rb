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
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
            FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, # 20
            IsNotZero, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, Transfer, Branch, Syscall, Transfer, # 30
            Transfer, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 40
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, # 50
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, SlotToReg, Branch, FunctionReturn, Transfer, # 60
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(16)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(29)
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
      sl = main_ticks(31)
      assert_transfer(sl, :r8 ,:r0)
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_move_sys_return
      sl = main_ticks(36)
      assert_reg_to_slot( sl , :r1 ,:r2 , 5)
    end
    def test_return
      done = main_ticks(59)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
