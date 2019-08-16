require_relative "../helper"

module Risc
  class BlockAssignOuter < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = 15 ;yielder {a = 10 ; return 15} ; return a")
      super
    end

    def test_chain
      # show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, LoadConstant, LoadConstant, SlotToReg, SlotToReg, # 10
            RegToSlot, RegToSlot, RegToSlot, Branch, RegToSlot,
            SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg, # 20
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, SlotToReg, Branch, FunctionCall, LoadConstant, # 30
            SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg,
            LoadConstant, SlotToReg, SlotToReg, RegToSlot, RegToSlot, # 40
            RegToSlot, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, SlotToReg, LoadConstant, RegToSlot, SlotToReg, # 50
            SlotToReg, SlotToReg, DynamicJump, LoadConstant, SlotToReg,
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, RegToSlot, # 60
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, Branch, RegToSlot, RegToSlot, SlotToReg, # 70
            SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot,
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 80
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot, # 90
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, Branch, # 100
            SlotToReg, SlotToReg, FunctionReturn, Transfer, SlotToReg,
            SlotToReg, Syscall, NilClass, ]
      assert_equal 10 , get_return
    end

    def test_block_jump
      load_ins = main_ticks(53)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
    end
    def test_block_load
      load_ins = main_ticks(54)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 10 , @interpreter.get_register(load_ins.register).value
    end
    def test_block_slot1
      assert_slot_to_reg main_ticks(55) ,:r0 , 6 , :r2
    end
    def test_block_slot2
      assert_slot_to_reg main_ticks(56) ,:r2 , 6 , :r2
    end
    def test_block_slot3
      assert_slot_to_reg main_ticks(57) ,:r2 , 3 , :r2
    end
    def test_block_reg
      assert_reg_to_slot main_ticks(58) ,:r1 , :r2 , 1
    end
  end
end
