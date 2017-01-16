require_relative "helper"

module Register
  class TestInterpretByteToReg < MiniTest::Test
    include Ticker

    def setup
        @string_input = <<HERE
  class Space
    int main()
      "Hello".get_internal_byte(1)
    end
  end
HERE
      @input =  s(:statements, s(:call,
                   :get_internal_byte,
                  s(:arguments, s(:int, 1)),
                    s(:receiver, s(:string, "Hello"))))
      super
    end

    def test_chain
      #show_ticks # get output of what is
      check_chain [Branch, Label, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, FunctionCall, Label, SlotToReg,
             LoadConstant, RegToSlot, LoadConstant, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, RegToSlot, RegisterTransfer, FunctionCall, Label,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, ByteToReg, RegToSlot, Label, FunctionReturn,
             RegisterTransfer, SlotToReg, SlotToReg, LoadConstant, SlotToReg,
             RegToSlot, Label, FunctionReturn, RegisterTransfer, Syscall,
             NilClass]
    end

    def test_branch
      was = @interpreter.instruction
      assert_equal Branch , ticks(1).class
      assert was != @interpreter.instruction
      assert @interpreter.instruction , "should have gone to next instruction"
    end
    def test_load
      assert_equal LoadConstant ,  ticks(3).class
      assert_equal Parfait::Space , @interpreter.get_register(:r2).class
      assert_equal :r2,  @interpreter.instruction.array.symbol
    end
    def test_get
      assert_equal SlotToReg , ticks(4).class
      assert @interpreter.get_register( :r1 )
      assert Integer , @interpreter.get_register( :r1 ).class
    end
    def test_call
      assert_equal FunctionCall ,  ticks(8).class
    end
    def test_exit
      done = ticks(46)
      assert_equal NilClass ,  done.class
    end

    def test_byte_to_reg
      done = ticks(32)
      assert_equal ByteToReg ,  done.class
      assert_equal "H".ord ,  @interpreter.get_register(done.register)
    end

  end
end
