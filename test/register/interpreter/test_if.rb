require_relative "helper"

class IfTest < MiniTest::Test
  include Ticker

  def setup
    @string_input = <<HERE
class Space
  int itest(int n)
    if_zero( n - 12)
      "then".putstring()
    else
      "else".putstring()
    end
  end

  int main()
    itest(20)
  end
end
HERE
    @input = s(:statements,
              s(:class, :Space,
                s(:derives, nil),
                s(:statements,
                  s(:function, :Integer,
                    s(:name, :itest),
                    s(:parameters,
                      s(:parameter, :Integer, :n)),
                    s(:statements,
                      s(:if_statement, :zero,
                        s(:condition,
                          s(:operator_value, :-,
                            s(:name, :n),
                            s(:int, 12))),
                        s(:true_statements,
                          s(:call,
                            s(:name, :putstring),
                            s(:arguments),
                            s(:receiver,
                              s(:string, "then")))),
                        s(:false_statements,
                          s(:call,
                            s(:name, :putstring),
                            s(:arguments),
                            s(:receiver,
                              s(:string, "else"))))))),
                  s(:function, :Integer,
                    s(:name, :main),
                    s(:parameters),
                    s(:statements,
                      s(:call,
                        s(:name, :itest),
                        s(:arguments,
                          s(:int, 20))))))))
    super
  end

  def test_if
      #show_ticks # get output of what is
      check_chain ["Branch","Label","LoadConstant","GetSlot","SetSlot",
     "LoadConstant","SetSlot","FunctionCall","Label","GetSlot",
     "GetSlot","SetSlot","LoadConstant","SetSlot","LoadConstant",
     "SetSlot","LoadConstant","SetSlot","LoadConstant","SetSlot",
     "RegisterTransfer","FunctionCall","Label","GetSlot","LoadConstant",
     "OperatorInstruction","IsZero","GetSlot","LoadConstant","SetSlot",
     "LoadConstant","SetSlot","LoadConstant","SetSlot","LoadConstant",
     "SetSlot","RegisterTransfer","FunctionCall","Label","GetSlot",
     "GetSlot","RegisterTransfer","Syscall","RegisterTransfer","RegisterTransfer",
     "SetSlot","Label","FunctionReturn","RegisterTransfer","GetSlot",
     "GetSlot","Branch","Label","Label","FunctionReturn",
     "RegisterTransfer","GetSlot","GetSlot","Label","FunctionReturn",
     "RegisterTransfer","Syscall","NilClass"]
  end
end
