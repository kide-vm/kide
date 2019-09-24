class Integer < Data4
  def <(right)
    X.comparison(:<)
  end
  def +(right)
    X.int_operator(:+)
  end
end
class Space
  def main(arg)
    n = 6
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
end
#Space.new.main(1)
