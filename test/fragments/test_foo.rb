require_relative 'helper'

class TestFoo < MiniTest::Test
  include Fragments

  def test_foo2
    @string_input = <<HERE
class Object
  int foo(int x)
    int a = 5
    return a
  end

  int main()
    foo( 4 )
  end
end
HERE
    @expect =  [ Virtual::Return ]
    check
  end


end
