require_relative 'helper'

class TestIf < MiniTest::Test
  include Fragments

  def test_if_plus
    @string_input = <<HERE
class Object
  int main()
    int n = 10
    if_plus( n - 12)
      return 3
    else
      return 4
    end
  end
end
HERE
    @length = 25
    check_return 4
  end

  def test_if_zero
    @string_input = <<HERE
class Object
  int main()
    int n = 10
    if_zero(n - 10 )
      "10".putstring()
    end
  end
end
HERE
  @length = 47
  @stdout = "10"
  check
  end


  def test_if_minus
    @string_input = <<HERE
class Object
  int itest(int n)
    if_minus( n - 12)
      "then".putstring()
    else
      "else".putstring()
    end
  end

  int main()
    itest(20)
  end
end
HERE
  @length = 62
  @stdout = "else"
  check
  end
end
