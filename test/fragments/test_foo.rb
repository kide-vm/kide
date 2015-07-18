require_relative 'helper'

class TestFoo < MiniTest::Test
  include Fragments

  def test_foo2
    @string_input = <<HERE
def foo(x)
  a = 5
end
3.foo( 4 )
HERE
    @expect =  [Parfait::Method , Virtual::Return ]
    check
  end

  def test_foo
    @string_input = <<HERE
3.foo( 4 )
HERE
    @expect =  [Virtual::Return ]
    check
  end

end
