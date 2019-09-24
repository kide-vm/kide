class Integer < Data4
  def <(right)
    X.comparison(:<)
  end
  def +(right)
    X.int_operator(:+)
  end
  def -(right)
    X.int_operator(:-)
  end
end

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
    return fibo_r(5)
  end
end
