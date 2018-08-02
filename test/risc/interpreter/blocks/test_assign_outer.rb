require_relative "../helper"

module Risc
  class BloclAssignOuter < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = 15 ;yielder {a = 10 ; return 15} ; return a")
      super
    end

    def test_pest_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, LoadConstant, LoadConstant, SlotToReg, RegToSlot,
             RegToSlot, SlotToReg, SlotToReg, Branch, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, SlotToReg, Branch, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall,
             LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
             SlotToReg, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg,
             SlotToReg, RegToSlot, RegToSlot, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, Branch, SlotToReg, SlotToReg,
             DynamicJump, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, RegToSlot, Branch, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, Branch,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg,
             SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             Branch, SlotToReg, SlotToReg, Branch, RegToSlot,
             SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer,
             SlotToReg, SlotToReg, Branch, Syscall, NilClass]
      assert_equal 10 , get_return
    end

    def test_pest_block_jump
      load_ins = main_ticks(66)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
    end
    def test_pest_block_load
      load_ins = main_ticks(67)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 10 , @interpreter.get_register(load_ins.register).value
    end
    def test_pest_block_slot1
      assert_slot_to_reg main_ticks(68) ,:r0 , 6 , :r2
    end
    def test_pest_block_slot2
      assert_slot_to_reg main_ticks(69) ,:r2 , 6 , :r2
    end
    def test_pest_block_slot3
      assert_slot_to_reg main_ticks(70) ,:r2 , 3 , :r2
    end
    def test_pest_block_reg
      assert_reg_to_slot main_ticks(71) ,:r1 , :r2 , 1
    end
  end
end
