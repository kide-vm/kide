require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def test_while_fibo
    @string_input = <<HERE
class Object
  int fibonaccit(int n)
      int a = 0
      int b = 1
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
    fibonaccit( 10 )
  end
end
HERE
    @length = 5
    check
  end

end
