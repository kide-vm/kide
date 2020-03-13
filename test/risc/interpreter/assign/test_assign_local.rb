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
      check_main_chain [LoadConstant, RegToSlot, SlotToReg, RegToSlot, Branch, #5
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #10
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, #15
                 NilClass,] #20
      assert_equal Parfait::Integer , get_return.class
      assert_equal 15 , get_return.value
    end
    def test_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_15
      assert_load 1 , Parfait::Integer , "id_integer_"
      assert_equal 15 , @interpreter.get_register(@interpreter.instruction.register).value
    end
    def test_branch
      assert_branch 5 , "return_label"
    end
    def test_return
      ret = main_ticks(11)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
    def test_transfer
      assert_transfer 12 , :message , :saved_message
    end
    def test_sys
      assert_syscall 15 , :exit
    end
  end
end
