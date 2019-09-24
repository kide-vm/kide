class Integer < Data4
  def <(right)
    X.comparison(:<)
  end
  def +(right)
    X.int_operator(:+)
  end
end
class Word < Data8
  def putstring
    X.putstring
  end
end
class Space
  def times(n)
    i = 0
    while( i < n )
      yield
      i = i + 1
    end
    return n
  end
  def main(arg)
    return times(5) {
      "1".putstring
    }
  end
end
