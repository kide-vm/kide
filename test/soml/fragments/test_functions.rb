require_relative 'helper'

class TestFunctions < MiniTest::Test
  include Fragments

  def test_functions
    @string_input = <<HERE
class Object

  int times(int a, int b)
    if_zero( b + 0)
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
    @length = 505
    check_return 80
  end

  def test_class_method
    @string_input = <<HERE
class Object

  int self.some()
    return 5
  end

  int main()
    return Object.some()
  end
end
HERE
  @length = 33
  check_return 5
  end

  def test_class_method_fails
    @string_input = <<HERE
class Object
  int main()
    return Object.som()
  end
end
HERE
    assert_raises {check}
  end


end
