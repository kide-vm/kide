require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
class Object
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
  int fib_print(int n)
    int fib = fibonaccir( n )
    fib.putint()
  end
  int main()
    fib_print(10)
  end
end
HERE
  @expect =  [[Virtual::MethodEnter,Register::GetSlot,Virtual::Set,Virtual::Set,
            Virtual::Set,Virtual::Set,Virtual::MethodCall] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end
end
