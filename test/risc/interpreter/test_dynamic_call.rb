require_relative "helper"

module Risc
  class InterpreterDynamicCall < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 15 ; return a.div10")
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, LoadConstant, RegToSlot, LoadConstant, RegToSlot,
             FunctionCall, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
             IsZero, SlotToReg, SlotToReg, LoadConstant, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, LoadConstant, FunctionCall,
             Label, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             Label, LoadConstant, SlotToReg, OperatorInstruction, IsZero,
             Label, Transfer, Syscall, NilClass]
      #assert_equal 1 , get_return
    end

    def test_call_main
      call_ins = ticks(26)
      assert_equal FunctionCall , call_ins.class
      assert_equal  :main , call_ins.method.name
    end
    def test_call_resolve
      call_ins = ticks(70)
      assert_equal FunctionCall , call_ins.class
      assert_equal  :resolve_method , call_ins.method.name
    end
    def test_label
      call_ins = ticks(71)
      assert_equal Label , call_ins.class
      assert_equal  "Word_Type.resolve_method" , call_ins.name
    end
    def test_arg_15_to_resolve
      sl = ticks( 74 )
      assert_equal SlotToReg , sl.class
      assert_equal :r2 , sl.array.symbol #load from message
      assert_equal 2 , sl.index
      assert_equal :r2 , sl.register.symbol
      assert_equal Parfait::Integer, @interpreter.get_register( :r2 ).class
      assert_equal 15, @interpreter.get_register( :r2 ).value
    end

    def est_dyn
      cal = ticks(102)
      assert_equal DynamicJump ,  cal.class
    end
    #should end in exit, but doesn't, becasue resolve never returns
    def ttest_sys
      sys = ticks(20)
      assert_equal Syscall ,  sys.class
    end
    def ttest_return
      ret = ticks(18)
      assert_equal FunctionReturn ,  ret.class
      link = @interpreter.get_register( ret.register )
      assert_equal Label , link.class
    end
  end
end
