require_relative "helper"

module Risc
  class InterpreterWhileSimle < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = true; while( a ); a = false;end;return a'
      super
    end

    def test_if
        #show_main_ticks # get output of what is in main
        check_main_chain [Label, LoadConstant, SlotToReg, RegToSlot, Label,
             SlotToReg, SlotToReg, LoadConstant, OperatorInstruction, IsZero,
             LoadConstant, OperatorInstruction, IsZero, LoadConstant, SlotToReg,
             RegToSlot, Branch, Label, SlotToReg, SlotToReg,
             LoadConstant, OperatorInstruction, IsZero, Label, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, FunctionReturn, Transfer, Syscall,
             NilClass]
      assert_kind_of Parfait::FalseClass , get_return
    end
    def test_load_false_const
      load = main_ticks(2)
      assert_equal LoadConstant , load.class
      assert_kind_of Parfait::TrueClass , load.constant
    end
    def test_load_false
      load = main_ticks(8)
      assert_equal LoadConstant , load.class
      assert_equal Parfait::FalseClass , load.constant.class
    end
    def test_compare
      op = main_ticks(9)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
    end
    def test_not_zero
      check = main_ticks(10)
      assert_equal IsZero , check.class
      assert check.label.name.start_with?("merge_label") , check.label.name
    end
    def test_compare2
      op = main_ticks(12)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
    end
    def test_not_zero2
      check = main_ticks(13)
      assert_equal IsZero , check.class
      assert check.label.name.start_with?("merge_label") , check.label.name
    end
    def test_exit
      done = main_ticks(35)
      assert_equal Syscall ,  done.class
    end
  end
end
