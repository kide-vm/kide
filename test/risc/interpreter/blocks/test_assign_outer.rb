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
      check_main_chain    [LoadConstant, RegToSlot, LoadConstant, LoadConstant, SlotToReg,
            SlotToReg, RegToSlot, RegToSlot, RegToSlot, RegToSlot, # 10
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg, # 20
            FunctionCall, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
            SlotToReg, LoadConstant, SlotToReg, SlotToReg, RegToSlot, # 30
            RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            RegToSlot, SlotToReg, LoadConstant, RegToSlot, SlotToReg, # 40
            SlotToReg, DynamicJump, LoadConstant, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, RegToSlot, Branch, SlotToReg, # 50
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 60
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot, # 70
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, # 80
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 90
            Transfer, SlotToReg, SlotToReg, Syscall, NilClass, ]
      assert_equal 10 , get_return
    end

    def base ; 42 ; end
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
