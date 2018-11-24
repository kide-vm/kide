require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      #show_base_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, # 20
            FunctionCall, LoadConstant, SlotToReg, LoadConstant, OperatorInstruction,
            IsNotZero, SlotToReg, RegToSlot, SlotToReg, Branch, # 30
            SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot, # 40
            LoadConstant, SlotToReg, RegToSlot, Branch, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, # 50
            SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
            Branch, Branch, SlotToReg, SlotToReg, RegToSlot, # 60
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg, # 70
            SlotToReg, Syscall, NilClass, ]
       assert_equal 10 , get_return
    end
    def base_ticks(num)
      main_ticks(22 + num)
    end
    def test_load_5
      lod = main_ticks( 12 )
      assert_load( lod , Parfait::Integer , :r1)
      assert_equal 5 , lod.constant.value
    end
    def test_load_receiver
      sl = base_ticks( 7 )
      assert_slot_to_reg( sl , :r0 , 2 , :r2)
    end
    def test_reduce_receiver
      sl = base_ticks( 9 )
      assert_slot_to_reg( sl , :r2 , 2 , :r2)
    end
    def test_slot_args #load args from message
      sl = base_ticks( 10 )
      assert_slot_to_reg( sl , :r0 , 8 , :r3)
    end
    def test_slot_arg_int #load arg 1, destructively from args
      sl = base_ticks( 11 )
      assert_slot_to_reg( sl , :r3 , 1 , :r3)
    end
    def test_reduce_arg
      sl = base_ticks( 12 )
      assert_slot_to_reg( sl , :r3 , 2 , :r3)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_op
      op = base_ticks(13)
      assert_equal OperatorInstruction , op.class
      assert_equal :+ , op.operator
      assert_equal :r2 , op.left.symbol
      assert_equal :r3 , op.right.symbol
      assert_equal 10 , @interpreter.get_register(:r2)
      assert_equal 5 , @interpreter.get_register(:r3)
    end
    def test_move_res_to_int
      int = base_ticks( 14 )
      assert_reg_to_slot( int , :r2 , :r1 , 2)
    end
    def test_move_int_to_reg
      int = base_ticks( 15 )
      assert_reg_to_slot( int , :r1 , :r0 , 5)
    end
    def test_move_fix_to_result
      sl = base_ticks( 16 )
      assert_slot_to_reg( sl , :r0 , 5 , :r1)
    end
    def test_start_return_sequence
      sl = base_ticks( 17 )
      assert_slot_to_reg( sl , :r0 , 6 , :r2)
    end
  end
end
