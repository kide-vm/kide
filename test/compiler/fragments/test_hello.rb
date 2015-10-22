require_relative 'helper'

class TestHello < MiniTest::Test
  include Fragments

  def test_hello
    @string_input = <<HERE
class Object
  int main()
    "Hello Raisa, I am salama".putstring()
  end
end
HERE
    @expect = [[SaveReturn,Register::Set,Register::GetSlot,Register::Set,
                Register::Set,RegisterTransfer,FunctionCall] ,[RegisterTransfer,GetSlot,FunctionReturn]]
    check
  end
end
