require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include RuntimeTests

  def test_puti
    @string_input = <<HERE
Word five = 4.to_s()
five.putstring()
HERE
    @stdout = "5"
    check
  end


end
