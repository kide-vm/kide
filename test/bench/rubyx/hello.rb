class Space
  # ran with --parfait=25000
  def main(arg)
    b = 10000
    while( b >= 1 )
      b = b - 1
      "Hello-there\n".putstring
    end
    return b
  end
end
