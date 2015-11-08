require_relative "helper"

class MultTest < MiniTest::Test
  include Ticker
  include AST::Sexp

  def setup
    @string_input = <<HERE
class Object
  int main()
    return #{2**31} * #{2**31}
  end
end
HERE
    super
  end

  def test_mult
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
