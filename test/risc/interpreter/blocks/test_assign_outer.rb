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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, LoadConstant,
            SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot, # 10
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg, # 20
            RegToSlot, SlotToReg, FunctionCall, LoadConstant, SlotToReg,
            OperatorInstruction, IsZero, SlotToReg, SlotToReg, LoadConstant, # 30
            SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg, # 40
            LoadConstant, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            DynamicJump, LoadConstant, SlotToReg, SlotToReg, SlotToReg, # 50
            RegToSlot, LoadConstant, RegToSlot, Branch, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot, # 60
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, # 70
            RegToSlot, Branch, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 80
            SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg,
            SlotToReg, Branch, RegToSlot, LoadConstant, SlotToReg, # 90
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, # 100
            NilClass, ]
      assert_equal 10 , get_return
    end

    def test_block_jump
      load_ins = main_ticks(46)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
    end
    def test_block_load
      load_ins = main_ticks(47)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 10 , @interpreter.get_register(load_ins.register).value
    end
    def test_block_slot1
      assert_slot_to_reg main_ticks(48) ,:r0 , 6 , :r2
    end
    def test_block_slot2
      assert_slot_to_reg main_ticks(49) ,:r2 , 6 , :r2
    end
    def test_block_slot3
      assert_slot_to_reg main_ticks(50) ,:r2 , 3 , :r2
    end
    def test_block_reg
      assert_reg_to_slot main_ticks(51) ,:r1 , :r2 , 1
    end
    def test_ret_load
      load_ins = main_ticks(52)
      assert_load load_ins , Parfait::Integer , :r1
      assert_equal 15 , @interpreter.get_register(load_ins.register).value
    end
  end
end
