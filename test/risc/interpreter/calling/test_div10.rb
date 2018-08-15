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
            SlotToReg, FunctionCall, SlotToReg, SlotToReg, Transfer, # 20
            Transfer, LoadData, OperatorInstruction, LoadData, OperatorInstruction,
            OperatorInstruction, LoadData, Transfer, OperatorInstruction, OperatorInstruction, # 30
            Branch, LoadData, Transfer, OperatorInstruction, OperatorInstruction,
            LoadData, Transfer, OperatorInstruction, OperatorInstruction, LoadData, # 40
            OperatorInstruction, LoadData, Transfer, OperatorInstruction, Branch,
            OperatorInstruction, Transfer, LoadData, OperatorInstruction, LoadData, # 50
            OperatorInstruction, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
            RegToSlot, RegToSlot, RegToSlot, Branch, SlotToReg, # 60
            SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
            RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn, # 70
            SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
            RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, # 80
            Branch, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
            SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, # 90
            SlotToReg, SlotToReg, Syscall, NilClass, ]
       assert_equal 2 , get_return
    end

    def test_load_space
      load_ins = main_ticks 53
      assert_load load_ins, Parfait::Space
    end
    def test_load_to
      to = main_ticks 54
      assert_slot_to_reg to , :r5 , 5 ,:r2
    end
    def test_load_25
      load_ins = main_ticks 9
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 25 , @interpreter.get_register(load_ins.register).value
    end
    def test_return_class
      ret = main_ticks(70)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Fixnum , link.class
    end
  end
end
