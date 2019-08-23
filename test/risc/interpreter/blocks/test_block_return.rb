require_relative "../helper"

module Risc
  class BlockReturn < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = yielder {return 15} ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain   [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, # 20
            SlotToReg, OperatorInstruction, IsZero, SlotToReg, LoadConstant,
            SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot, # 30
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
            LoadConstant, RegToSlot, SlotToReg, SlotToReg, DynamicJump, # 40
            LoadConstant, RegToSlot, Branch, SlotToReg, SlotToReg,
            RegToSlot, LoadConstant, SlotToReg, RegToSlot, RegToSlot, # 50
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg,
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, # 60
            LoadConstant, SlotToReg, Branch, RegToSlot, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, # 70
            RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg,
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, Branch, # 80
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall, # 90
            NilClass, ]
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(36)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(40)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
