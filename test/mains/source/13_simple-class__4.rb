class Integer < Data4
  def +(right)
    X.int_operator(:+)
  end
end
class Space
  def self.simple
    return 2 + 2
  end
  def main(arg)
    return Space.simple
  end
end
