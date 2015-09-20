require_relative 'helper'

class TestPutint < MiniTest::Test
  include Fragments

  def test_putint
    @string_input = <<HERE
42.putint()
HERE
    @expect = []
    check
  end
end
