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
