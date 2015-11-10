require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include RuntimeTests

  def test_as_char1
    @string_input = <<HERE
return 5.as_char()
HERE
    check_return 53
  end

  def test_as_char2
    @string_input = <<HERE
return 10.as_char()
HERE
    check_return 32
  end

  def test_tos_one_digit
    @string_input = <<HERE
Word five = 5.to_s()
five.putstring()
HERE
    @stdout = " 5"
    check
  end

  def test_tos_zero
    @string_input = <<HERE
Word five = 0.to_s()
five.putstring()
HERE
    @stdout = " 0"
    check
  end

  def test_tos_two_digit
    @string_input = <<HERE
Word five = 15.to_s()
five.putstring()
HERE
    @stdout = " 15"
    check
  end

  def test_tos_three_digit
    @string_input = <<HERE
Word five = 150.to_s()
five.putstring()
HERE
    @stdout = " 150"
    check
  end

  def test_puti_four_digit
    @string_input = "return 1234.puti()"
    @stdout = " 1234"
    check_return 1234
  end

  def test_puti_seven_digit
    @string_input = "return 1234567.puti()"
    @stdout = " 1234567"
    check_return 1234567
  end
  def test_puti_eigth_digit
    @string_input = "return 123445678.puti()"
    @stdout = " 123445678"
    check_return 123445678
  end
end
