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
      check_main_chain  [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, SlotToReg, #15
                 LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, RegToSlot, #20
                 SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, #25
                 RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #35
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #40
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #45
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #50
       assert_equal 10 , get_return
    end
    def base_ticks(num)
      main_ticks(13 + num)
    end
    def test_base
        assert_equal FunctionCall , main_ticks( 13 ).class
    end
    def test_load_factory
      lod = base_ticks( 1 )
      assert_load( lod , Parfait::Factory , :r2)
      assert_equal :next_integer , lod.constant.attribute_name
    end
    def test_slot_receiver #load next_object from factory
      sl = base_ticks( 2 )
      assert_slot_to_reg( sl , :r2 , 2 , :r1)
    end
    def test_load_nil
      lod = base_ticks( 3 )
      assert_load( lod , Parfait::NilClass , :r3)
    end
    def test_nil_check
      op = base_ticks(4)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
      assert_equal :r3 , op.left.symbol
      assert_equal :r1 , op.right.symbol
      assert_equal ::Integer , @interpreter.get_register(:r3).class
      assert 0 != @interpreter.get_register(:r3)
    end
    def test_branch
      br = base_ticks( 5 )
      assert_equal IsNotZero , br.class
      assert br.label.name.start_with?("cont_label")
    end
    def test_load_next_int
      sl = base_ticks( 6 )
      assert_slot_to_reg( sl , :r1 , 1 , :r4)
    end
    def test_move_next_back_to_factory
      int = base_ticks( 7 )
      assert_reg_to_slot( int , :r4 , :r2 , 2)
    end
  end
end
