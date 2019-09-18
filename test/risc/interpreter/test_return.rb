require_relative "helper"

module Risc
  class InterpreterReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, RegToSlot, Branch, SlotToReg, SlotToReg, #5
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #10
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #15
      assert_equal 5 , get_return
    end

    def est_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_function_return
      ret = main_ticks(10)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal ::Integer , link.class
    end
  end
end
