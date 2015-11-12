require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include RuntimeTests

  def test_mod4
    [2,3,4,5,10,12].each do |m|
      @string_input = "return #{m}.mod4()"
      check_return m % 4
    end
  end
  def test_mod10
    [2,3,4,5,10,12,55].each do |m|
      @string_input = "return #{m}.mod10()"
      check_return m % 10
    end
  end

  def test_div10
    [2,5,10,12 , 55 ].each do |m|
      @string_input = "return #{m}.div10()"
      check_return m / 10
    end
  end
  
  def test_as_char1
    @string_input = "return 5.as_char()"
    check_return 53
  end

  def test_as_char2
    @string_input = "return 10.as_char()"
    check_return 32
  end

  def test_tos_one_digit
    @string_input = "Word five = 5.to_s()
five.putstring()"
    @stdout = " 5"
    check
  end

  def test_tos_zero
    @string_input = "Word five = 0.to_s()
five.putstring()"
    @stdout = " 0"
    check
  end

  def test_tos_two_digit
    @string_input = "Word five = 15.to_s()
five.putstring()"
    @stdout = " 15"
    check
  end

  def test_tos_three_digit
    @string_input = "Word five = 150.to_s()
five.putstring()"
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
