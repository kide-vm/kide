require_relative 'helper'

class TestReturn < MiniTest::Test
  include Fragments

  def check_return val
    check
    assert_equal Parfait::Message , @interpreter.get_register(:r1).class
    assert_equal val , @interpreter.get_register(:r1).return_value
  end
  def test_return1
    @string_input = <<HERE
class Object
  int main()
    return 5
  end
end
HERE
    @length = 18
    check_return 5
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
    @length = 38
    check_return 5
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
    @length = 42
    check_return 5
  end

end
