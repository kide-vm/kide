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
      check_main_chain [LoadConstant, RegToSlot, LoadConstant, SlotToReg, RegToSlot, #5
                 SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, #15
                 FunctionCall, LoadConstant, SlotToReg, OperatorInstruction, IsZero, #20
                 SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #25
                 RegToSlot, SlotToReg, LoadConstant, RegToSlot, SlotToReg, #30
                 SlotToReg, DynamicJump, LoadConstant, SlotToReg, SlotToReg, #35
                 RegToSlot, LoadConstant, RegToSlot, Branch, SlotToReg, #40
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #45
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #50
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #55
                 FunctionReturn, SlotToReg, RegToSlot, Branch, SlotToReg, #60
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg, #65
                 FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, #70
                 NilClass,] #75
      assert_equal 10 , get_return
    end
    def base ; 32 ; end

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
