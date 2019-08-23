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
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #10
                 LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, #15
                 SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg, #20
                 Transfer, Syscall, Transfer, Transfer, SlotToReg, #25
                 RegToSlot, SlotToReg, Branch, SlotToReg, RegToSlot, #30
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, #45
                 SlotToReg, SlotToReg, Syscall, NilClass,] #50
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(10)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(22)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(:r0)
      assert_equal Parfait::Word , @interpreter.get_register(:r1).class
      assert_equal "Hello again" , @interpreter.get_register(:r1).to_string
    end
    def test_move_sys_return
      sl = main_ticks(23)
      assert_transfer(sl, :r0 ,:r3)
      assert_equal 11 , @interpreter.get_register(:r3)
    end
    def test_restore_message
      sl = main_ticks(24)
      assert_transfer(sl, :r8 ,:r0)
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_move_sys_return
      sl = main_ticks(30)
      assert_reg_to_slot( sl , :r1 ,:r2 , 5)
    end
    def test_return
      done = main_ticks(44)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
