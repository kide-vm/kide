require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
int fib_print(int n)
  int fib = fibonaccir( n )
  fib.putint()
end
int fibonaccir( int n )
  if( n <= 1 )
    return n
  else
    int tmp
    tmp = n - 1
    int a = fibonaccir( tmp )
    tmp = n - 2
    int b = fibonaccir( tmp )
    return a + b
  end
end

fib_print(10)
HERE
  @expect =  [Virtual::Return ]
  check
  end
end
