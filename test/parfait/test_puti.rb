require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include RuntimeTests

  def test_puti
    @string_input = <<HERE
5.puts()
HERE
    @stdout = "5"
    check
  end


end
