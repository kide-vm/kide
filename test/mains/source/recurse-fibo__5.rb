class Space

  def fibo_r( n )
    if( n <  2 )
      return n
    else
      a = fibo_r(n - 1)
      b = fibo_r(n - 2)
      return a + b
    end
  end

  def main(arg)
    return fibo_r(10)
  end
end
