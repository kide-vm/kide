require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def fibo num
    @string_input = <<HERE
class Object
  int fibonaccit(int n)
      int a = 0
      int b = 1
      n = n - 1
      while_plus( n )
        int tmp = a
        a = b
        b = tmp + b
        n = n - 1
      end
      b.putint()
      return b
  end

  int main()
    return fibonaccit( 100 )
  end
end
HERE
    @string_input.sub!( "100" , num.to_s )
  end

  def test_while_fibo100
    fibo 100
    @length = 2345
    #TODO bug, int max is 92 ruby converts to biginteger.
    check_return  354224848179261915075
  end

  def test_while_fibo92
    fibo 92
    @length = 2161
    check_return  7540113804746346429
  end

end
