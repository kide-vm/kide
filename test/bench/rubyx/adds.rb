class Space

  def fibo_i(fib)
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

  # ran with --integers=1600000 , result -noop * 25
  def main(arg)
    b = 2000
    while( b >= 1 )
      b = b - 1
      fibo_i(40)
    end
    return b
  end
end
