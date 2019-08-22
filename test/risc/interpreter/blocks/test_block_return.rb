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
      check_main_chain  [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall, # 20
            LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg,
            SlotToReg, LoadConstant, SlotToReg, SlotToReg, RegToSlot, # 30
            RegToSlot, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            RegToSlot, SlotToReg, LoadConstant, RegToSlot, SlotToReg, # 40
            SlotToReg, SlotToReg, DynamicJump, LoadConstant, RegToSlot,
            Branch, SlotToReg, SlotToReg, RegToSlot, LoadConstant, # 50
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
            SlotToReg, FunctionReturn, SlotToReg, RegToSlot, Branch, # 60
            SlotToReg, SlotToReg, RegToSlot, Branch, LoadConstant,
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg, # 70
            SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
            SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg, # 80
            SlotToReg, Branch, RegToSlot, LoadConstant, SlotToReg,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg, # 90
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall,
            NilClass, ]
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(38)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(43)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
