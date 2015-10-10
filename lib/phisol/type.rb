
module Phisol
  # Integer and (Object) References are the main derived classes, but float will come.

  class Type
    def == other
      return false unless other.class == self.class
      return true
    end

    # map from a type sym (currently :int/:ref) to a class of subtype of Type
    # TODO needs to be made extensible in a defined way.
    def self.from_sym type
      return type if type.is_a? Type
      case type
      when :int
        self.int
      when :ref
        self.ref
      else
        raise "No type maps to:#{type} (#{type.class})"
      end
    end

    def self.int
      return Integer.new
    end
    def self.ref
      return Reference.new
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
