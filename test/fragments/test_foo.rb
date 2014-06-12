require_relative 'helper'

class TestFoo < MiniTest::Test
  include Fragments

  def test_foo
    @string_input = <<HERE
def foo(x) 
  a = 5
end
3.foo( 4 )
HERE
    @should = [0x0,0x40,0x2d,0xe9,0x5,0x0,0xa0,0xe3,0x0,0x80,0xbd,0xe8]
    @output = ""
    parse 
    @target = [:Object , :foo]
    write "foo"
  end
end

