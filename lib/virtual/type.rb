
module Virtual
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Unknown Type has unknown type and has only casting methods. So it must be cast to be useful.
  class Type
    def == other
      return false unless other.class == self.class
      return true
    end
  end

  class Integer < Type
  end

  class Reference < Type
    # possibly unknown value, but known class (as in methods)
    def initialize clazz = nil
      @of_class = clazz
    end
    attr_reader :of_class
  end

  class Unknown < Type
  end

end
