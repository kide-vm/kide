class Space
  def if_small( n )
    if( n < 10)
      "small".putstring
      return 10
    else
      return 20
    end
  end
  def main(arg)
    return if_small( 8 )
  end
end
