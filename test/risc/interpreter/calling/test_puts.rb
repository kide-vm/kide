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
                 FunctionCall, LoadConstant, LoadConstant, SlotToReg, OperatorInstruction, #15
                 IsNotZero, SlotToReg, RegToSlot, RegToSlot, SlotToReg, #20
                 SlotToReg, Transfer, Transfer, Transfer, Syscall, #25
                 Transfer, Transfer, SlotToReg, Branch, RegToSlot, #30
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #35
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #40
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, #50
                 SlotToReg, Syscall, NilClass,] #55
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal Integer , get_return.class
       assert_equal 11 , get_return #bytes written
    end
    def test_call
      cal =  main_ticks(11)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_pre_sys
      done = main_ticks(24)
      assert_equal Parfait::Word , @interpreter.get_register(:syscall_1).class
      assert_equal "Hello again" , @interpreter.get_register(:syscall_1).to_string
      assert_equal 11 , @interpreter.get_register(:syscall_2)
    end

    def test_sys
      done = main_ticks(25)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(:syscall_1)
    end

    def test_move_sys_return
      assert_transfer(26, :syscall_1 ,:integer_tmp)
      assert_equal 11 , @interpreter.get_register(:integer_tmp)
    end
    def test_restore_message
      assert_transfer(27, :saved_message ,:message)
      assert_equal Parfait::Message , @interpreter.get_register(:message).class
    end
    def test_return
      done = main_ticks(48)
      assert_equal FunctionReturn ,  done.class
    end

  end
end
