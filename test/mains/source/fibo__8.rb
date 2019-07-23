class Space
  def main(arg)
    n = 10
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
