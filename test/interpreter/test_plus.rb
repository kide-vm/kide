require_relative "helper"

class PlusTest < MiniTest::Test
  include Ticker

  def setup
    @string_input = <<HERE
class Object
  int main()
    return #{2**62 - 1} + 1
  end
end
HERE
    super
  end

  def test_add
    #show_ticks # get output of what is
    check_chain ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","FunctionCall","Label","LoadConstant",
     "LoadConstant","OperatorInstruction","SetSlot","Label","FunctionReturn",
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
