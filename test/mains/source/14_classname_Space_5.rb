class Word < Data8
  def putstring
    X.putstring
  end
end
class Class < Behaviour
  def name
    @name
  end
end
class Type
  def name
    @object_class.name
  end
end
class Space
  def type
    @type
  end
  def main(arg)
    type.name.putstring
  end
end
