require_relative 'helper'

class TestHello < MiniTest::Test
  include Fragments

  def test_hello
    @string_input = <<HERE
class Space
  int main()
    "Hello Raisa, I am salama".putstring()
  end
end
HERE
    @length = 37
    @stdout = "Hello Raisa, I am salama"
    check
  end
end
