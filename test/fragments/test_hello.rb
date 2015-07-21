require_relative 'helper'

class TestHello < MiniTest::Test
  include Fragments

  def test_hello
    @string_input = <<HERE
"Hello Raisa, I am salama".putstring()
HERE
    @expect = []
    check
  end
end
