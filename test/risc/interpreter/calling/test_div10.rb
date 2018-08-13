require_relative "../helper"

module Risc
  class InterpreterDiv10 < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 25.div10")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
            RegToSlot, RegToSlot, RegToSlot, LoadConstant, SlotToReg, # 10
            RegToSlot, LoadConstant, SlotToReg, Branch, RegToSlot,
            SlotToReg, FunctionCall, SlotToReg, SlotToReg, SlotToReg, # 20
            SlotToReg, SlotToReg, SlotToReg, LoadData, OperatorInstruction,
            LoadData, OperatorInstruction, OperatorInstruction, LoadData, Transfer, # 30
            Branch, OperatorInstruction, OperatorInstruction, LoadData, Transfer,
            OperatorInstruction, OperatorInstruction, LoadData, Transfer, OperatorInstruction, # 40
            OperatorInstruction, LoadData, OperatorInstruction, LoadData, Branch,
            Transfer, OperatorInstruction, OperatorInstruction, Transfer, LoadData, # 50
            OperatorInstruction, LoadData, OperatorInstruction, OperatorInstruction, LoadConstant,
            SlotToReg, SlotToReg, RegToSlot, Branch, RegToSlot, # 60
            RegToSlot, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
            SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg, # 70
            SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
            SlotToReg, SlotToReg, RegToSlot, Branch, SlotToReg, # 80
            SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg,
            RegToSlot, RegToSlot, SlotToReg, SlotToReg, SlotToReg, # 90
            FunctionReturn, Transfer, SlotToReg, SlotToReg, Syscall,
            NilClass, ]
       assert_equal 2 , get_return
    end

    def test_load_space
      load_ins = main_ticks 55
      assert_load load_ins, Parfait::Space
    end
    def test_load_to
      to = main_ticks 56
      assert_slot_to_reg to , :r5 , 5 ,:r2
    end
    def test_load_25
      load_ins = main_ticks 9
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return_class
      ret = main_ticks(72)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Fixnum , link.class
    end
  end
end
