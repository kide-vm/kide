require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("return 5 + 5")
      super
    end
#FIXME should be mom macro test, no need to interpret
    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, Branch, SlotToReg, SlotToReg, RegToSlot, #35
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #40
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Syscall, NilClass,] #55
       assert_equal 10 , get_return
    end
    def base_ticks(num)
      main_ticks(14 + num)
    end
    def est_base
        cal = main_ticks( 14 )
        assert_equal FunctionCall , cal.class
    end
    def est_load_receiver
      sl = base_ticks( 8 )
      assert_slot_to_reg( sl , :r0 , 2 , :r2)
    end
    def est_reduce_receiver
      sl = base_ticks( 9 )
      assert_slot_to_reg( sl , :r2 , 2 , :r2)
    end
    def est_slot_args #load args from message
      sl = base_ticks( 10 )
      assert_slot_to_reg( sl , :r0 , 9 , :r3)
    end
    def est_reduce_arg
      sl = base_ticks( 11 )
      assert_slot_to_reg( sl , :r3 , 2 , :r3)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_op
      op = base_ticks(12)
      assert_equal OperatorInstruction , op.class
      assert_equal :+ , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 10 , @interpreter.get_register(:r2)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_move_res_to_int
      int = base_ticks( 13 )
      assert_reg_to_slot( int , :r2 , :r1 , 2)
    end
    def test_move_int_to_reg
      int = base_ticks( 14 )
      assert_reg_to_slot( int , :r1 , :r0 , 5)
    end
  end
end
