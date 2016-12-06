require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def fibo num
    @string_input = <<HERE
class Space
  int fibonaccit(int n)
      int a = 0
      int b = 1
      while_plus( n - 2)
        n = n - 1
        int tmp = a
        a = b
        b = tmp + b
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

  def test_while_fibo48
    fibo 48
    @length = 1241
    # this is not the correct fibo, just what comes from wrapping (smaller than below)
    check 512559680
  end

  # highest 32 bit fibo
  def test_while_fibo47
    fibo 47
    @length = 1216
    check 2971215073
  end

end
