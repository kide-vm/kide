class Space

  def fibo_i(fib)
    a = 0
    b = fib
    while( a < b )
      a = a + 1
      b = b - 1
    end
    return a
  end

  # ran with --parfait=100000
  # (time - noop) * 25 + noop
  def main(arg)
    b = 4000
    while( b >= 1 )
      b = b - 1
      fibo_i(20)
    end
    return b
  end
end
