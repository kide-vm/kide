require_relative "../helper"

module Risc
  class BlockAssignOuter < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = 15 ;yielder {a = 10 ; return 15} ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain  [LoadConstant, RegToSlot, LoadConstant, RegToSlot, SlotToReg, #5
                 SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #10
                 LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, #15
                 LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #25
                 LoadConstant, RegToSlot, SlotToReg, SlotToReg, DynamicJump, #30
                 LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #35
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #40
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #45
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #50
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #55
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #60
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, #65
                 SlotToReg, SlotToReg, Syscall, NilClass,] #70
      assert_equal 10 , get_return
    end
    def base ; 30 ; end

    def test_block_jump
      load_ins = main_ticks(base)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
    end
    def test_block_load
      load_ins = main_ticks(base+1)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 10 , @interpreter.get_register(load_ins.register).value
    end
    def test_block_slot1
      assert_slot_to_reg main_ticks(base+2) ,:r0 , 6 , :r2
    end
    def test_block_slot2
      assert_slot_to_reg main_ticks(base+3) ,:r2 , 6 , :r2
    end
    def test_block_reg
      assert_reg_to_slot main_ticks(base+4) ,:r1 , :r2 , 16
    end
    def test_ret_load
      load_ins = main_ticks(base+5)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 15 , @interpreter.get_register(load_ins.register).value
    end
  end
end
