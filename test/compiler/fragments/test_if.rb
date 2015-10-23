require_relative 'helper'

class TestIf < MiniTest::Test
  include Fragments

  def test_if_basic
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
  @length = 26
  check
  end

  def test_if_small
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
  @length = 45
  @stdout = "10"
  check
  end


  def test_if_puts
    @string_input = <<HERE
class Object
  int itest(int n)
    if_zero( n - 12)
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
  @length = 57
  @stdout = "else"
  check
  end
end
