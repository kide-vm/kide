
module Virtual
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Unknown Type has unknown type and has only casting methods. So it must be cast to be useful.
  class Type
    def == other
      return false unless other.class == self.class
      return true
    end

    # map from a type sym (currently :int/:ref) to a class of subtype of Type
    # TODO needs to be made extensible in a defined way.  
    def self.from_sym type
      case type
      when :int
        Virtual::Integer
      when :ref
        Virtual::Reference
      else
        raise "No type maps to:#{type}"
      end
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

end
