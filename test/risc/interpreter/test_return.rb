require_relative "helper"

module Risc
  class InterpreterAdd < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 5")
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, LoadConstant,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             Transfer]
    end

    def test_call_main
      call_ins = ticks(8)
      assert_equal FunctionCall , call_ins.class
      assert  :main , call_ins.method.name
    end
    def test_load_5
      load_ins = ticks 10
      assert_equal LoadConstant ,  load_ins.class
      assert_equal 5 , @interpreter.get_register(load_ins.register).value 
    end

    def pest_call
      ret = ticks(18)
      assert_equal FunctionReturn ,  ret.class

      object = @interpreter.get_register( ret.register )
      link = object.get_internal_word( ret.index )

      assert_equal Label , link.class
    end
    def pest_adding
      done_op = ticks(12)
      assert_equal OperatorInstruction ,  done_op.class
      left = @interpreter.get_register(done_op.left)
      rr = done_op.right
      right = @interpreter.get_register(rr)
      assert_equal Fixnum , left.class
      assert_equal Fixnum , right.class
      assert_equal 7 , right
      assert_equal 12 , left
      done_tr = ticks(1)
      assert_equal RegToSlot ,  done_tr.class
      result = @interpreter.get_register(done_op.left)
      assert_equal result , 12
    end
  end
end
