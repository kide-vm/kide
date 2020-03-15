require_relative "../helper"

module Risc
  # Test the alloc sequence used by all integer operations
  class InterpreterIntAlloc < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, #40
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #45
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Transfer, #50
                 Syscall, NilClass,] #55
       assert_equal 10 , get_return
    end

    def test_load_factory
      assert_load( 15 , Parfait::Factory , "id_factory_")
      assert_equal :next_integer , @instruction.constant.attribute_name
    end
    def test_load_nil
      assert_load( 16 , Parfait::NilClass , "id_nilclass_")
    end
    def test_slot_receiver #load next_object from factory
      assert_slot_to_reg( 17 , "id_factory_" , 2 , "id_factory_.next_object")
    end
    def test_nil_check
      assert_operator 18 , :- ,  "id_nilclass_" , "id_factory_.next_object" , "op_-_"
      value = @interpreter.get_register(@instruction.result)
      assert_equal ::Integer , value.class
      assert 0 != value
    end
    def test_branch
      assert_not_zero 19 , "cont_label"
    end
    def test_load_next_int
      assert_slot_to_reg( 20 , "id_factory_.next_object" , 1 , "id_factory_.next_object.next_integer")
    end
    def test_move_next_back_to_factory
      assert_reg_to_slot( 21 , "id_factory_.next_object.next_integer" , "id_factory_" , 2)
    end
  end
end
