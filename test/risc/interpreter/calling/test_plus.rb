require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal 10 , get_return
    end
    def test_op
      assert_operator 26, :+ ,  :r2 ,  :r4 , :r1
      assert_equal 10 , @interpreter.get_register(@instruction.result.symbol)
    end
    def test_move_res_to_int
      assert_reg_to_slot( 27 , :r1 , :r3 , 2)
    end
    def test_move_int_to_reg
      assert_reg_to_slot( 28 , :r3 , :r0 , 5)
    end
  end
end
