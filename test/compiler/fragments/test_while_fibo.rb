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

  def test_while_fibo94
    fibo 91
    @length = 2138
    # this is not the correct fibo, just what comes from wrapping (smaller than below)
    check_return 48360591948142405
  end

  def test_while_fibo90
    fibo 90
    @length = 2115
    check_return 2880067194370816120
  end

end
