class FakeInt
  attr_reader :value
  def initialize(val)
    set_value(val)
  end
  def is_a?(clazz)
    clazz == Parfait::Integer
  end
  def byte_length
    4
  end
  def set_value(val)
    @value = val
  end
end
