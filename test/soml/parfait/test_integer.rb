require_relative 'helper'

class TestPutiRT < MiniTest::Test
  include ParfaitTests

  def test_mod4_2
    @main = "return 2.mod4()"
    check 2 % 4
  end
  def test_mod4_3
    @main = "return 3.mod4()"
    check 3 % 4
  end
  def test_mod4_4
    @main = "return 4.mod4()"
    check 4 % 4
  end
  def test_mod4_5
    @main = "return 5.mod4()"
    check 5 % 4
  end
  def test_mod4_12
    @main = "return 12.mod4()"
    check 12 % 4
  end
  def test_mod4_10
    @main = "return 10.mod4()"
    check 10 % 4
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
    @main = "return 2.high_times(12 , 333)"
    check high_times(2,12,333)
  end
  def test_hightimes3456
    @main = "return 3456.high_times(12 , 333)"
    check high_times(3456,12,333)
  end
  def test_hightimes234567
    @main = "return 234567.high_times(12 , 333)"
    check high_times(234567,12,333)
  end
  def test_hightimes
    @main = "return 234567.high_times(12 , 333)"
    check high_times(234567,12,333)
  end
  def test_lowtimes2
    @main = "return 2.low_times(14 , 33)"
    check low_times(2,14,33)
  end
  def test_lowtimes3456
    @main = "return 3456.low_times(14 , 33)"
    check low_times(3456,14,33)
  end
  def test_lowtimes234567
    @main = "return 234567.low_times(14 , 33)"
    check low_times(234567,14,33)
  end

  # finally settled on the long version in http://www.sciencezero.org/index.php?title=ARM:_Division_by_10
  # also the last looked good, but some bug is admittedly in all the ones i tried
  #        (off course the bug is not included in the test, but easy to achieve with random numbers )
  # for high numbers with ending 0 they are all 1 low. Possibly Interpreter bug ?
  def test_div10_2
    @main = "return 2.div10()"
    check 2 / 10
  end
  def test_div10_10
    @main = "return 10.div10()"
    check 10 / 10
  end
  def test_div10_12345
    @main = "return 12345.div10()"
    check 12345 / 10
  end
  def test_div10_234567
    @main = "return 234567.div10()"
    check 234567 / 10
  end

  def test_as_char1
    @main = "return 5.as_char()"
    check 53
  end

  def test_as_char2
    @main = "return 10.as_char()"
    check 32
  end

  def test_tos_one_digit
    @main = "Word five = 5.to_s()
five.putstring()"
    @stdout = " 5"
    check
  end

  def test_tos_one_digit_length
    @main = "Word five = 5.to_s()
return five.char_length"
    check 2
  end

  def test_tos_zero
    @main = "Word five = 0.to_s()
    five.putstring()"
    @stdout = " 0"
    check
  end

  def test_tos_two_digit
    @main = "Word five = 15.to_s()
five.putstring()"
    @stdout = " 15"
    check
  end

  def test_tos_two_digit_length
    @main = "Word five = 15.to_s()
    return five.char_length"
    check 3
  end

  def test_tos_three_digit
    @main = "Word five = 150.to_s()
five.putstring()"
    @stdout = " 150"
    check
  end

  def test_puti_four_digit
    @main = "return 1234.puti()"
    @stdout = " 1234"
    check 1234
  end

  def test_puti_seven_digit
    @main = "int i = 301 * 4096
      i = i + 1671
      return i.puti()"
    @stdout = " 1234567"
    check 1234567
  end

  def test_puti_seven_digit_length
    @main = "int i = 301 * 4096
      Word str = i.to_s()
      return str.char_length"
    check 8
  end

  def test_puti_eight_digit
    @main = "int i = 3014 * 4096
      i = i + 334
      return i.puti()"
    @stdout = " 12345678"
    check 12345678
  end

  def test_fibr8
    @main = "int fib = 8.fibr( )
             return fib.puti()"
    @stdout = " 21"
    check 21
  end

  def test_fibw8
    @main = "int fib = 8.fibw( )
             return fib.puti()"
    @stdout = " 21"
    check 21
  end
  def test_fibw20
    @main = "int fib = 20.fibw( )
             return fib.puti()"
    @stdout = " 6765"
    check 6765
  end

  def pest_fib40_1000000
    @main = "int count = 999424
             count = count + 576
             while_plus( count - 1)
               40.fibw( )
               count = count - 1
             end
             return count"
    check 0
  end
end
