class Space

  def fibo_r( n )
     if( n <  2 )
       return n
     end
     a = fibo_r(n - 1)
     b = fibo_r(n - 2)
     return a + b
  end

  # ran with --parfait=70000
  def main(arg)
    b = 2
    res = 0
    while( b >= 1 )
      b = b - 1
      res = fibo_r(20)
    end
    return res
  end
end
