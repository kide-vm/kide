require_relative "helper"

class AddTest < MiniTest::Test
  include Ticker
  include AST::Sexp

  def setup
    @string_input = <<HERE
class Object
  int main()
    return 5 + 10
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
  end

  def test_mult
    @string_input = <<HERE
class Object
  int main()
    return 5 * 10
  end
end
HERE
    setup
    #show_ticks # get output of what is
    check_chain ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","FunctionCall","Label","LoadConstant",
     "LoadConstant","OperatorInstruction","SetSlot","Label","FunctionReturn",
     "RegisterTransfer","Syscall","NilClass"]
  end

end
