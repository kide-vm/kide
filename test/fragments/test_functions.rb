require_relative 'helper'

class TestFunctions < MiniTest::Test
  include Fragments

  def test_functions
    @string_input = <<HERE
int minus(int a,int b)
    return a - b
end

int plus(int a, int b)
  return a + b
end

int times(int a, int b)
  if( b == 0 )
    a = 0
  else
    int m = minus(b, 1)
    int t = times(a, m)
    a = plus(a,t)
  end
end

int t_seven()
  int tim = times(7,6)
  tim.putint()
end

t_seven()
HERE
  @expect =  [Virtual::Return ]
  check

  end
end
