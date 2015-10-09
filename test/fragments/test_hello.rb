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
    @expect = [[Virtual::MethodEnter,Virtual::Set,Virtual::NewMessage,Virtual::Set,
                Virtual::Set,Virtual::MethodCall] ,[Virtual::MethodReturn]]
    check
  end
end
