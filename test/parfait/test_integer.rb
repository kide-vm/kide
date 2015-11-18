require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include RuntimeTests

  def test_mod4_2
    @string_input = "return 2.mod4()"
    check_return 2 % 4
  end
  def test_mod4_3
    @string_input = "return 3.mod4()"
    check_return 3 % 4
  end
  def test_mod4_4
    @string_input = "return 4.mod4()"
    check_return 4 % 4
  end
  def test_mod4_5
    @string_input = "return 5.mod4()"
    check_return 5 % 4
  end
  def test_mod4_12
    @string_input = "return 12.mod4()"
    check_return 12 % 4
  end
  def test_mod4_10
    @string_input = "return 10.mod4()"
    check_return 10 % 4
  end

  # if you multiply i by "by" the return is the high 32 bits
  def high_times( i ,  by_high ,  by_low)
    by = by_high * 65536 + by_low
    by *= i
    by /= 65536
    by /= 65536
    return  by
  end

  # if you multiply i by "by" the return is the low 32 bits
  def low_times( i ,  by_high ,  by_low)
    by = by_high * 65536 + by_low
    by *= i
    return  (by & 0xffffffff)
  end

  def test_hightimes2
    @string_input = "return #{2}.high_times(12 , 333)"
    check_return high_times(2,12,333)
  end
  def test_hightimes3456
    @string_input = "return #{3456}.high_times(12 , 333)"
    check_return high_times(3456,12,333)
  end
  def test_hightimes234567
    @string_input = "return #{234567}.high_times(12 , 333)"
    check_return high_times(2,12,333)
  end
  def test_hightimes
    @string_input = "return #{234567}.high_times(12 , 333)"
    check_return high_times(234567,12,333)
  end
  def test_lowtimes2
    @string_input = "return #{2}.low_times(14 , 33)"
    check_return low_times(2,14,33)
  end
  def test_lowtimes3456
    @string_input = "return #{3456}.low_times(14 , 33)"
    check_return low_times(3456,14,33)
  end
  def test_lowtimes234567
    @string_input = "return #{234567}.low_times(14 , 33)"
    check_return low_times(234567,14,33)
  end

  # finally settled on the long version in http://www.sciencezero.org/index.php?title=ARM:_Division_by_10
  # also the last looked good, but some bug is admittedly in all the ones i tried
  #        (off course the bug is not included in the test, but easy to achieve with random numbers )
  # for high numbers with ending 0 they are all 1 low. Possibly Interpreter bug ?
  def test_div10_2
    @string_input = "return 2.div10()"
    check_return 2 / 10
  end
  def test_div10_10
    @string_input = "return 10.div10()"
    check_return 10 / 10
  end
  def test_div10_12345
    @string_input = "return 12345.div10()"
    check_return 12345 / 10
  end
  def test_div10_234567
    @string_input = "return 234567.div10()"
    check_return 234567 / 10
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
    @string_input = "int i = 301 * 4096
      i = i + 1671
      return i.puti()"
    @stdout = " 1234567"
    check_return 1234567
  end
  def test_puti_eight_digit
    @string_input = "int i = 3014 * 4096
      i = i + 334
      return i.puti()"
    @stdout = " 12345678"
    check_return 12345678
  end
end
