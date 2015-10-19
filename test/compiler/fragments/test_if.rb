require_relative 'helper'

class TestIf < MiniTest::Test
  include Fragments

  def test_if_basic
    @string_input = <<HERE
class Object
  int main()
    int n = 10
    if( n - 12)
      return 3
    else
      return 4
    end
  end
end
HERE
  @length = 17
  check
  end

  def test_if_small
    @string_input = <<HERE
class Object
  int main()
    int n = 10
    if(8 - n )
      "10".putstring()
    end
  end
end
HERE
  @length = 33
  @stdout = "10"
  check
  end


  def test_if_puts
    @string_input = <<HERE
class Object
  int itest(int n)
    if( n - 12)
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
  @length = 40
  @stdout = "else"
  check
  end
end
