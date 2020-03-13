require_relative "helper"

module Risc
  class InterpreterReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain [LoadConstant, RegToSlot, Branch, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer, #10
                 SlotToReg, SlotToReg, Syscall, NilClass,] #15
      assert_equal 5 , get_return.value
    end

    def test_call_main
      assert_function_call 0 , :main
    end
    def test_function_return
      ret = main_ticks(9)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Parfait::ReturnAddress , link.class
    end
  end
end
