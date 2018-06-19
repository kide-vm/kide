require_relative "../helper"

module Risc
  class InterpreterWhileSimle < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = true; while( a ); a = false;end;return a'
      super
    end

    def test_if
        #show_main_ticks # get output of what is in main
        check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             LoadConstant, OperatorInstruction, IsZero, LoadConstant, OperatorInstruction,
             IsZero, LoadConstant, SlotToReg, Branch, RegToSlot,
             Branch, SlotToReg, SlotToReg, LoadConstant, OperatorInstruction,
             IsZero, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, SlotToReg, Branch, SlotToReg,
             Syscall, NilClass]
      assert_kind_of Parfait::NilClass , get_return
    end
    def test_load_false_const
      load = main_ticks(1)
      assert_equal LoadConstant , load.class
      assert_kind_of Parfait::TrueClass , load.constant
    end
    def base
      6
    end
    def test_load_false
      load = main_ticks(base)
      assert_equal LoadConstant , load.class
      assert_equal Parfait::FalseClass , load.constant.class
    end
    def test_compare
      op = main_ticks(base+1)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
    end
    def test_not_zero
      check = main_ticks(base + 2)
      assert_equal IsZero , check.class
      assert check.label.name.start_with?("merge_label") , check.label.name
    end
    def test_compare2
      op = main_ticks(base + 4)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
    end
    def test_not_zero2
      check = main_ticks(base + 5)
      assert_equal IsZero , check.class
      assert check.label.name.start_with?("merge_label") , check.label.name
    end
    def test_exit
      done = main_ticks(36)
      assert_equal Syscall ,  done.class
    end
  end
end
