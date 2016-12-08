require_relative "helper"

class MultTest < MiniTest::Test
  include Ticker
  include AST::Sexp

  def setup
    @string_input = <<HERE
class Space
  int main()
    return #{2**31} * #{2**31}
  end
end

HERE
    @input = s(:statements,
              s(:class, :Space,
                s(:derives, nil),
                s(:statements,
                  s(:function, :Integer,
                    s(:name, :main),
                    s(:parameters),
                    s(:statements,
                      s(:return,
                        s(:operator_value, :*,
                          s(:int, 2147483648),
                          s(:int, 2147483648))))))))
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
