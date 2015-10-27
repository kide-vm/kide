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
    int tim = times(5,3)
    tim.putint()
  end

  int main()
    return t_seven()
  end
end
HERE
  @length = 191
  check

  end
end
