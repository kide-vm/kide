require_relative "helper"

module Risc
  class TestPuts < MiniTest::Test
    include Ticker

    def setup
        @string_input = <<HERE
  class Space
    int main()
      "Hello again".putstring()
    end
  end
HERE
      @input = s(:statements, s(:call, :putstring, s(:arguments), s(:receiver, s(:string, "Hello again"))))
      super
    end

    def pest_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, SlotToReg,
             LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, LoadConstant, RegToSlot, Transfer,
             FunctionCall, Label, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, Transfer, Syscall, Transfer,
             Transfer, RegToSlot, Label, FunctionReturn, Transfer,
             SlotToReg, SlotToReg, LoadConstant, SlotToReg, RegToSlot,
             Label, FunctionReturn, Transfer, Syscall, NilClass]
    end

    def pest_branch
      was = @interpreter.instruction
      assert_equal Branch , ticks(1).class
      assert was != @interpreter.instruction
      assert @interpreter.instruction , "should have gone to next instruction"
    end
    def pest_load
      assert_equal LoadConstant ,  ticks(3).class
      assert_equal Parfait::Space , @interpreter.get_register(:r2).class
      assert_equal :r2,  @interpreter.instruction.array.symbol
    end
    def pest_get
      assert_equal SlotToReg , ticks(4).class
      assert @interpreter.get_register( :r1 )
      assert Integer , @interpreter.get_register( :r1 ).class
    end
    def pest_call
      assert_equal FunctionCall ,  ticks(8).class
    end

    def pest_putstring
      done = ticks(29)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
    end

    def pest_return
      done = ticks(34)
      assert_equal FunctionReturn ,  done.class
      assert Label , @interpreter.instruction.class
      assert @interpreter.instruction.is_a?(Instruction) , "not instruction #{@interpreter.instruction}"
    end

    def pest_exit
      done = ticks(45)
      assert_equal NilClass ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
    end
  end
end
