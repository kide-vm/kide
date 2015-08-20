require_relative 'helper'

class TestFoo < MiniTest::Test
  include Fragments

  def test_foo2
    @string_input = <<HERE
def foo2(x)
  a = 5
end
3.foo( 4 )
HERE
    @expect =  [ Virtual::Return ]
    check
  end

  def test_foo
    @string_input = "3.foo( 4 )"
    @expect =  [Virtual::Return ]
    check
  end

  def test_add
    @string_input = "2 + 5"
    @expect =  [Virtual::Return ]
    check
  end

end
