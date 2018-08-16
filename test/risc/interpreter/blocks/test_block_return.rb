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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, LoadConstant,
            SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot, # 10
            RegToSlot, SlotToReg, SlotToReg, Branch, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot, # 20
            LoadConstant, SlotToReg, RegToSlot, SlotToReg, FunctionCall,
            LoadConstant, SlotToReg, OperatorInstruction, IsZero, SlotToReg, # 30
            SlotToReg, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, Branch, SlotToReg, # 40
            SlotToReg, RegToSlot, SlotToReg, LoadConstant, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, DynamicJump, LoadConstant, # 50
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 60
            SlotToReg, SlotToReg, Branch, FunctionReturn, SlotToReg,
            SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, # 70
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 80
            SlotToReg, Branch, SlotToReg, FunctionReturn, SlotToReg,
            SlotToReg, Branch, RegToSlot, SlotToReg, SlotToReg, # 90
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot,
            LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg, # 100
            Branch, SlotToReg, SlotToReg, FunctionReturn, Transfer,
            SlotToReg, SlotToReg, Syscall, NilClass, ]
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(44)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(49)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
