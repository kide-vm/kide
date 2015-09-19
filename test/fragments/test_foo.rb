require_relative 'helper'

class TestFoo < MiniTest::Test
  include Fragments

  def test_foo2
    @string_input = <<HERE
int foo(int x)
  int a = 5
  return a
end
3.foo( 4 )
HERE
    @expect =  [ Virtual::Return ]
    check
  end


end
