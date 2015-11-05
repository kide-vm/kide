require_relative 'helper'

class TestFunctions < MiniTest::Test
  include Fragments

  def test_functions
    @string_input = <<HERE
class Object

  int times(int a, int b)
    if_zero( b )
      a = 0
    else
      int m = b - 1
      int t = times(a, m)
      a = a + t
    end
    return a
  end

  int t_seven()
    int tim = times(8,10)
    tim.putint()
    return tim
  end

  int main()
    return t_seven()
  end
end
HERE
  @length = 486
  check_return 80
  end
end
