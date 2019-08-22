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
      check_main_chain  [LoadConstant, SlotToReg, RegToSlot, LoadConstant, LoadConstant,
            SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot, # 10
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 20
            SlotToReg, FunctionCall, LoadConstant, SlotToReg, OperatorInstruction,
            IsZero, SlotToReg, LoadConstant, SlotToReg, SlotToReg, # 30
            RegToSlot, RegToSlot, RegToSlot, RegToSlot, SlotToReg,
            SlotToReg, RegToSlot, SlotToReg, LoadConstant, RegToSlot, # 40
            SlotToReg, SlotToReg, DynamicJump, LoadConstant, SlotToReg,
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot, # 50
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg, # 60
            SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch,
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, # 70
            Branch, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot, # 80
            Branch, SlotToReg, SlotToReg, RegToSlot, Branch,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 90
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg,
            SlotToReg, Syscall, NilClass, ]
      assert_equal 10 , get_return
    end

    def base ; 43 ; end
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
    def test_block_slot3
      assert_slot_to_reg main_ticks(base+4) ,:r2 , 3 , :r2
    end
    def test_block_reg
      assert_reg_to_slot main_ticks(base+5) ,:r1 , :r2 , 1
    end
    def test_ret_load
      load_ins = main_ticks(base+6)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 15 , @interpreter.get_register(load_ins.register).value
    end
  end
end
