require_relative "../helper"

module Risc
  class InterpreterMinusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 6 - 5")
      super
    end

    def test_minus
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, Branch, FunctionCall, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             RegToSlot, SlotToReg, Branch, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, Branch, FunctionReturn, Transfer, Syscall,
             NilClass]
       assert_equal Parfait::Integer , get_return.class
       assert_equal 1 , get_return.value
    end
    def test_load_5
      lod = main_ticks( 20 )
      assert_equal LoadConstant , lod.class
      assert_equal Parfait::Integer , lod.constant.class
      assert_equal 5 , lod.constant.value
    end
    def test_op
      op = main_ticks(35)
      assert_equal OperatorInstruction , op.class
      assert_equal :r1 , op.left.symbol
      assert_equal :r2 , op.right.symbol
      assert_equal 5 , @interpreter.get_register(:r2)
      assert_equal 1 , @interpreter.get_register(:r1)
    end
    def test_return
      ret = main_ticks(63)
      assert_equal FunctionReturn ,  ret.class
      assert_equal :r1 ,  ret.register.symbol
      assert_equal 18628 ,  @interpreter.get_register(ret.register)
    end
    def test_sys
      sys = main_ticks(65)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end
  end
end
