require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_add
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
             SlotToReg, Branch, FunctionReturn, SlotToReg, SlotToReg,
             Branch, Transfer, Syscall, NilClass]
       assert_equal 10 , get_return
    end
    def test_load_5
      lod = main_ticks( 20 )
      assert_equal LoadConstant , lod.class
      assert_equal Parfait::Integer , lod.constant.class
      assert_equal 5 , lod.constant.value
    end
    def base
      30
    end
    def test_slot_receiver #load receiver from message
      sl = main_ticks( base )
      assert_equal SlotToReg , sl.class
      assert_equal :r0 , sl.array.symbol #load from message
      assert_equal 2 , sl.index
      assert_equal :r1 , sl.register.symbol
    end
    def test_slot_args #load args from message
      sl = main_ticks( base + 1 )
      assert_equal SlotToReg , sl.class
      assert_equal :r0 , sl.array.symbol #load from message
      assert_equal 8 , sl.index
      assert_equal :r2 , sl.register.symbol
    end
    def test_slot_arg #load arg 1, destructively from args
      sl = main_ticks( base + 2 )
      assert_equal SlotToReg , sl.class
      assert_equal :r2 , sl.array.symbol #load from message
      assert_equal 1 , sl.index
      assert_equal :r2 , sl.register.symbol
    end
    def test_slot_int1 #load int from object
      sl = main_ticks( base + 3 )
      assert_equal SlotToReg , sl.class
      assert_equal :r1 , sl.array.symbol #load from message
      assert_equal 2 , sl.index
      assert_equal :r1 , sl.register.symbol
    end
    def test_op
      op = main_ticks(base + 5)
      assert_equal OperatorInstruction , op.class
      assert_equal :r1 , op.left.symbol
      assert_equal :r2 , op.right.symbol
      assert_equal 5 , @interpreter.get_register(:r2)
      assert_equal 10 , @interpreter.get_register(:r1)
    end
    def test_load_int_space
      cons = main_ticks(base + 6)
      assert_equal LoadConstant , cons.class
      assert_equal Parfait::Space , cons.constant.class
      assert_equal :r3 , cons.register.symbol
    end
    def test_load_int_next_space
      sl = main_ticks(base + 7)
      assert_equal SlotToReg , sl.class
      assert_equal :r3 , sl.array.symbol #load from space
      assert_equal 4 , sl.index
      assert_equal :r2 , sl.register.symbol
      assert_equal Parfait::Integer , @interpreter.get_register(:r2).class
    end
    def test_load_int_next_int
      sl = main_ticks(base + 8)
      assert_equal SlotToReg , sl.class
      assert_equal :r2 , sl.array.symbol #load from next_int
      assert_equal 1 , sl.index
      assert_equal :r4 , sl.register.symbol
      assert_equal Parfait::Integer , @interpreter.get_register(:r4).class
    end
    def test_load_int_next_int2
      sl = main_ticks(base + 9)
      assert_equal RegToSlot , sl.class
      assert_equal :r3 , sl.array.symbol #store to space
      assert_equal  4 , sl.index
      assert_equal :r4 , sl.register.symbol
    end
    def test_sys
      sys = main_ticks(68)
      assert_equal Syscall ,  sys.class
      assert_equal :exit ,  sys.name
    end
  end
end
