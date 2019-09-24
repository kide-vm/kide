class Integer < Data4
  def <(right)
    X.comparison(:<)
  end
end
class Word < Data8
  def putstring
    X.putstring
  end
end
class Space
  def if_small( n )
    if( n < 10)
      return 10
    else
      "large".putstring
      return 20
    end
  end
  def main(arg)
    return if_small( 12 )
  end
end
