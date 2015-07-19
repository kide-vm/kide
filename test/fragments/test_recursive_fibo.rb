require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
def fibonaccir( n )
      if( n <= 1 )
        return n
      else
        a = fibonaccir( n - 1 )
        b = fibonaccir( n - 2 )
        return a + b
      end
end
def fib_print(n)
  fib = fibonaccir( n )
  fib.putint()
end

fib_print(10)
HERE
  @expect =  [Virtual::Return ]
  check
  end
end
