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
      check_main_chain [LoadConstant, RegToSlot, SlotToReg, SlotToReg, RegToSlot, #5
                 LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #10
                 RegToSlot, SlotToReg, FunctionCall, LoadConstant, SlotToReg, #15
                 OperatorInstruction, IsZero, SlotToReg, RegToSlot, SlotToReg, #20
                 SlotToReg, RegToSlot, SlotToReg, LoadConstant, RegToSlot, #25
                 SlotToReg, SlotToReg, DynamicJump, LoadConstant, RegToSlot, #30
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #35
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #40
                 Branch, SlotToReg, SlotToReg, RegToSlot, SlotToReg, #45
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #50
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #55
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, #60
                 Transfer, SlotToReg, SlotToReg, Syscall, NilClass,] #65
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(24)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(28)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
