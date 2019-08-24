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
    return times(100000) {
      return 1
    }
  end
end
# 13 local
# 51 on pi
