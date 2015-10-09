require_relative 'helper'

class TestPutint < MiniTest::Test
  include Fragments

  def test_putint
    @string_input = <<HERE
class Object
  int main()
    42.putint()
  end
end
HERE
    @expect =  [ [Virtual::MethodEnter,Virtual::Set,Virtual::NewMessage,Virtual::Set,
                  Virtual::Set,Virtual::MethodCall] ,[Virtual::MethodReturn] ]
    check
  end
end
