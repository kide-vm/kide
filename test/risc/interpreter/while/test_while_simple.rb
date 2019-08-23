require_relative "../helper"

module Risc
  class InterpreterWhileSimle < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = true; while( a ); a = false;end;return a'
      super
    end

    def test_while
        #show_main_ticks # get output of what is in main
        check_main_chain  [LoadConstant, RegToSlot, SlotToReg, LoadConstant, OperatorInstruction,
            IsZero, LoadConstant, OperatorInstruction, IsZero, LoadConstant, # 10
            RegToSlot, Branch, SlotToReg, LoadConstant, OperatorInstruction,
            IsZero, SlotToReg, RegToSlot, Branch, SlotToReg, # 20
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 30
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
      assert_kind_of Parfait::NilClass , get_return
    end
    def test_load_false_const
      load = main_ticks(1)
      assert_equal LoadConstant , load.class
      assert_kind_of Parfait::TrueClass , load.constant
    end
    def base
      4
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
    def test_load_false
      load = main_ticks(base+3)
      assert_equal LoadConstant , load.class
      assert_equal Parfait::NilClass , load.constant.class
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
  end
end
