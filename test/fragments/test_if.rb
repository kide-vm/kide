require_relative 'helper'

class TestIf < MiniTest::Test
  include Fragments

  def test_if_basic
    @string_input = <<HERE
class Object
  int main()
    int n = 10
    if( n < 12)
      3
    else
      4
    end
  end
end
HERE
  @expect =  [Virtual::Return ]
  check
  end

  def test_return
    @string_input = <<HERE
class Object
  int main()
    return 5
  end
end
HERE
  @expect =  [Virtual::Return ]
  check
  end


  def test_if_function
    @string_input = <<HERE
class Object
  int itest(int n)
    if( n < 12)
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
  @expect =  [Virtual::Return ]
  check
  end
end
