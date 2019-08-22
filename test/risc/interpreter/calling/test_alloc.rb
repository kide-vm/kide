require_relative "../helper"

module Risc
  # Test the alloc sequence used by all integer operations
  class InterpreterIntAlloc < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, # 20
            SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, # 30
            Branch, OperatorInstruction, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 40
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, # 50
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
            Branch, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 60
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal 10 , get_return
    end
    def base_ticks(num)
      main_ticks(20 + num)
    end
    def test_load_factory
      lod = base_ticks( 0 )
      assert_load( lod , Parfait::Factory , :r2)
      assert_equal :next_integer , lod.constant.attribute_name
    end
    def test_slot_receiver #load next_object from factory
      sl = base_ticks( 1 )
      assert_slot_to_reg( sl , :r2 , 2 , :r1)
    end
    def test_load_nil
      lod = base_ticks( 2 )
      assert_load( lod , Parfait::NilClass , :r3)
    end
    def test_nil_check
      op = base_ticks(3)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
      assert_equal :r3 , op.left.symbol
      assert_equal :r1 , op.right.symbol
      assert_equal ::Integer , @interpreter.get_register(:r3).class
      assert 0 != @interpreter.get_register(:r3)
    end
    def test_branch
      br = base_ticks( 4 )
      assert_equal IsNotZero , br.class
      assert br.label.name.start_with?("cont_label")
    end
    def test_load_next_int
      sl = base_ticks( 5 )
      assert_slot_to_reg( sl , :r1 , 1 , :r4)
    end
    def test_move_next_back_to_factory
      int = base_ticks( 6 )
      assert_reg_to_slot( int , :r4 , :r2 , 2)
    end
    def test_branch_to_next_block
      br = base_ticks( 11 )
      assert_equal Branch , br.class
      assert_equal Parfait::BinaryCode ,  br.label.class
    end
  end
end
