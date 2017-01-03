require_relative "helper"

module Register
  class PlusTest < MiniTest::Test
    include Ticker

    def setup
      @string_input = <<HERE
  class Space
    int main()
      return #{2**62 - 1} + 1
    end
  end
HERE
      @input = s(:statements, s(:return, s(:operator_value, :+, s(:int, 4611686018427387903), s(:int, 1))))
      super
    end

    def test_add
      #show_ticks # get output of what is
      check_chain ["Branch","Label","LoadConstant","SlotToReg","RegToSlot",
       "LoadConstant","RegToSlot","FunctionCall","Label","LoadConstant",
       "LoadConstant","OperatorInstruction","RegToSlot","Label","FunctionReturn",
       "RegisterTransfer","Syscall","NilClass"]
      check_return 0
    end

    def test_overflow
      ticks( 12 )
      assert @interpreter.flags[:overflow]
    end

    def test_zero
      ticks( 12 )
      assert @interpreter.flags[:zero]
    end
  end
end
