require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include RuntimeTests

  def test_puti
    @string_input = <<HERE
Word five = 5.to_s()
five.putstring()
HERE
    @stdout = "5"
    check
  end


end
