require_relative "helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 + 5;return a")
      super
    end

    def test_add
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, FunctionCall,
             Label, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
             Label, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, Label, NilClass]
       assert_equal Parfait::Integer , get_return.class
#       assert_equal 10 , get_return.value
    end
    def test_load_5
      lod = ticks( 46 )
      assert_equal LoadConstant , lod.class
      assert_equal Parfait::Integer , lod.constant.class
      assert_equal 5 , lod.constant.value
    end
    def test_slot_receiver #load receiver from message
      sl = ticks( 57 )
      assert_equal SlotToReg , sl.class
      assert_equal :r0 , sl.array.symbol #load from message
      assert_equal 3 , sl.index
      assert_equal :r1 , sl.register.symbol
    end
    def test_slot_args #load args from message
      sl = ticks( 58 )
      assert_equal SlotToReg , sl.class
      assert_equal :r0 , sl.array.symbol #load from message
      assert_equal 9 , sl.index
      assert_equal :r2 , sl.register.symbol
    end
    def test_slot_arg #load arg 1, destructively from args
      sl = ticks( 59 )
      assert_equal SlotToReg , sl.class
      assert_equal :r2 , sl.array.symbol #load from message
      assert_equal 2 , sl.index
      assert_equal :r2 , sl.register.symbol
    end
    def test_slot_int1 #load int from object
      sl = ticks( 60 )
      assert_equal SlotToReg , sl.class
      assert_equal :r1 , sl.array.symbol #load from message
      assert_equal 3 , sl.index
      assert_equal :r1 , sl.register.symbol
    end
    def test_op
      op = ticks(62)
      assert_equal OperatorInstruction , op.class
      assert_equal :r1 , op.left.symbol
      assert_equal :r2 , op.right.symbol
      assert_equal 5 , @interpreter.get_register(:r2)
      assert_equal 10 , @interpreter.get_register(:r1)
    end
  end
end
