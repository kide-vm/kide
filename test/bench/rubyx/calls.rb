class Space

  def fibo_r(fib)
    n = fib
    a = 0
    b = 1
    i = 1
    while( i < n )
      result = a + b
      a = b
      b = result
      i = i + 1
    end
    return result
  end

  # ran with --parfait=80000
  # (time - noop) * 50 + noop
  def main(arg)
    b = 2000
    while( b >= 1 )
      b = b - 1
      fibo_r(20)
    end
    return b
  end
end
