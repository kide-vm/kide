class Integer < Data4
  def >=(right)
    X.comparison(:>=)
  end
  def -(right)
    X.int_operator(:-)
  end
end

class Space
  def main(arg)
    b = 10
    while( b >= 1 )
      b = b - 1
    end
    return b
  end
end
