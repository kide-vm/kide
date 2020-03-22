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
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 SlotToReg, OperatorInstruction, IsZero, SlotToReg, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant, #25
                 SlotToReg, RegToSlot, SlotToReg, SlotToReg, DynamicJump, #30
                 LoadConstant, RegToSlot, Branch, SlotToReg, SlotToReg, #35
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #40
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, FunctionReturn, SlotToReg, RegToSlot, #50
                 SlotToReg, RegToSlot, Branch, SlotToReg, SlotToReg, #55
                 RegToSlot, SlotToReg, SlotToReg, FunctionReturn, Transfer, #60
                 SlotToReg, SlotToReg, Transfer, Syscall, NilClass,] #65
      assert_equal 15 , get_return
    end

    def test_load_return
      load_ins = main_ticks(25)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::ReturnAddress , @interpreter.get_register(load_ins.register).class
    end

    def test_load_block
      load_ins = main_ticks(30)
      assert_equal DynamicJump ,  load_ins.class
      assert_equal Parfait::Block , @interpreter.get_register(load_ins.register).class
      assert_equal :main_block , @interpreter.get_register(load_ins.register).name
    end

  end
end
