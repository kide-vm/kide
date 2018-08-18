class Space

  def down( n )
    if( n <  2 )
      return n
    else
      a = down(n - 1)
      return a
    end
  end

  def main(arg)
    return down(10)
  end

end
