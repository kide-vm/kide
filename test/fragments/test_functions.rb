require_relative 'helper'

class TestFunctions < MiniTest::Test
  include Fragments

  def test_functions
    @string_input = <<HERE
def minus(a,b)
      a - b
end
def plus(a, b)
  a + b
end
def times(a, b)
  if( b == 0 )
    a = 0
  else
    m = minus(b, 1)
    t = times(a, m)
    a = plus(a,t)
  end
end
def t_seven()
  tim = times(7,6)
  tim.putint()
end

t_seven()
HERE
  @expect =  [Virtual::Return ]
  check

  end
end
