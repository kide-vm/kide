require_relative "../helper"

module Risc
  class BlockAssignLocal < MiniTest::Test
    include Ticker

    def setup
      @string_input = block_main("a = yielder {return 15} ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, LoadConstant,
             SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, Branch, RegToSlot,
             RegToSlot, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, Branch, SlotToReg, RegToSlot,
             SlotToReg, FunctionCall, LoadConstant, SlotToReg, OperatorInstruction,
             IsZero, SlotToReg, SlotToReg, LoadConstant, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             Branch, SlotToReg, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, Branch,
             SlotToReg, SlotToReg, DynamicJump, LoadConstant, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, Branch, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             Branch, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             Transfer, SlotToReg, SlotToReg, Branch, Syscall,
             NilClass]
      assert_equal 15 , get_return
    end

    def est_call_main
      call_ins = ticks(main_at)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def est_load_yield
      load_ins = main_ticks(4)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::CallableMethod , @interpreter.get_register(load_ins.register).class
      assert_equal :yielder , @interpreter.get_register(load_ins.register).name
    end
    def est_load_space
      load_ins = main_ticks(5)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::Space , @interpreter.get_register(load_ins.register).class
    end
    def est_op
      op = main_ticks(35)
      assert_equal OperatorInstruction ,  op.class
      assert_equal :- , op.operator
    end
    def est_load_block
      load_ins = main_ticks(39)
      assert_equal LoadConstant ,  load_ins.class
      assert_equal Parfait::Space , @interpreter.get_register(load_ins.register).class
    end

    def pest_sys
      sys = main_ticks(18)
      assert_equal Syscall ,  sys.class
    end
  end
end
