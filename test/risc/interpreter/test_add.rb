require_relative "helper"

module Risc
  class AddTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = <<HERE
  class Space
    def main(arg)
      return 5.mod4
    end
  end
HERE
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, LoadConstant, FunctionCall, Label,
             Label, NilClass]
    end

    def pest_get
      assert_equal SlotToReg , ticks(4).class
      assert @interpreter.get_register( :r2 )
      assert  Integer , @interpreter.get_register( :r2 ).class
    end
    def pest_transfer
      transfer = ticks 19
      assert_equal Transfer ,  transfer.class
      assert_equal @interpreter.get_register(transfer.to) , @interpreter.get_register(transfer.from)
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
