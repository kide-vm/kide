require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def test_while_fibo
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
    return fibonaccit( 10 )
  end
end
HERE
    @length = 278
    check
    assert_equal Parfait::Message , @interpreter.get_register(:r1).class
    assert_equal 55 , @interpreter.get_register(:r1).return_value
  end

end
