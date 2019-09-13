require_relative "../helper"

module Risc
  class TestPuts < MiniTest::Test
    include Ticker

    def setup
      @preload = "Word.put"
      @string_input = as_main(" return 'Hello again'.putstring ")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #10
                 FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction, #15
                 IsNotZero, SlotToReg, RegToSlot, RegToSlot, SlotToReg, #20
                 SlotToReg, Transfer, Syscall, Transfer, Transfer, #25
                 SlotToReg, RegToSlot, Branch, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #40
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #45
                 SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, #50
                 SlotToReg, Syscall, NilClass,] #55
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(11)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(23)
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
      sl = main_ticks(25)
      assert_transfer(sl, :r8 ,:r0)
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_move_sys_return
      sl = main_ticks(34)
      assert_reg_to_slot( sl , :r1 ,:r2 , 5)
    end
    def test_return
      done = main_ticks(48)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
