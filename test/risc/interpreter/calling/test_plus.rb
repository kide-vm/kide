require_relative "../helper"

module Risc
  class InterpreterPlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, # 20
            FunctionCall, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
            SlotToReg, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg, # 30
            RegToSlot, RegToSlot, RegToSlot, SlotToReg, Branch,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 40
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, # 50
            RegToSlot, Branch, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 60
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer,
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal 10 , get_return
    end
    def test_load_5
      lod = main_ticks( 12 )
      assert_load( lod , Parfait::Integer , :r1)
      assert_equal 5 , lod.constant.value
    end
    def base
      22
    end
    def test_slot_receiver #load receiver from message
      sl = main_ticks( base )
      assert_slot_to_reg( sl , :r0 , 2 , :r1)
    end
    def test_slot_args #load args from message
      sl = main_ticks( base + 1 )
      assert_slot_to_reg( sl , :r0 , 8 , :r2)
    end
    def test_slot_arg_int #load arg 1, destructively from args
      sl = main_ticks( base + 2 )
      assert_slot_to_reg( sl , :r2 , 1 , :r2)
    end
    def test_slot_int1 #load int from object
      sl = main_ticks( base + 3 )
      assert_slot_to_reg( sl , :r1 , 2 , :r1)
      assert_equal 5 , @interpreter.get_register(:r1)
    end
    def test_slot_int2 #load int from object
      sl = main_ticks( base + 4 )
      assert_slot_to_reg( sl , :r2 , 2 , :r2)
      assert_equal 5 , @interpreter.get_register(:r2)
    end
    def test_op
      op = main_ticks(base + 5)
      assert_equal OperatorInstruction , op.class
      assert_equal :+ , op.operator
      assert_equal :r1 , op.left.symbol
      assert_equal :r2 , op.right.symbol
      assert_equal 10 , @interpreter.get_register(:r1)
      assert_equal 5 , @interpreter.get_register(:r2)
    end
    def test_load_int_space
      cons = main_ticks(base + 6)
      assert_load( cons , Parfait::Factory , :r3)
    end
    def test_load_int_next_space
      sl = main_ticks(base + 7)
      assert_slot_to_reg( sl , :r3 , 2 , :r2)
      assert_equal Parfait::Integer , @interpreter.get_register(:r2).class
    end
    def test_load_int_next_int
      sl = main_ticks(base + 8)
      assert_slot_to_reg( sl , :r2 , 1 , :r4)
      assert_equal Parfait::Integer , @interpreter.get_register(:r4).class
    end
    def test_load_int_next_int2
      sl = main_ticks(base + 9)
      assert_reg_to_slot( sl , :r4 , :r3 , 2)
    end
  end
end
