require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
class Object
  int fibonaccir( int n )
    if_plus( n - 2 )
      int tmp
      tmp = n - 1
      int a = fibonaccir( tmp )
      tmp = n - 2
      int b = fibonaccir( tmp )
      return a + b
    else
      return n
    end
  end
  int fib_print(int n)
    int fib = fibonaccir( n )
    fib.putint()
    return fib
  end
  int main()
    return fib_print(8)
  end
end
HERE
  @length = 2525
  check_return 21
  end
end
