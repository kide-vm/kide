require_relative 'helper'

class TestReturn < MiniTest::Test
  include Fragments

  def test_return1
    @string_input = <<HERE
class Object
  int main()
    return 5
  end
end
HERE
    @length = 15
    check 5
  end

  def test_return2
    @string_input = <<HERE
class Object
  int foo(int x)
    return x
  end

  int main()
    return foo( 5 )
  end
end
HERE
    @length = 35
    check 5
  end

  def test_return3
    @string_input = <<HERE
class Object
  int foo(int x)
    int a = 5
    return a
  end

  int main()
    return foo( 4 )
  end
end
HERE
    @length = 39
    check 5
  end

end
