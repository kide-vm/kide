require_relative "value"

module Virtual
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Mystery Type has unknown type and has only casting methods. So it must be cast to be useful.
  class Type
    def == other
      return false unless other.class == self.class 
      return true
    end
  end
  
  class Integer < Type
  end
  
  class Reference < Type
  end
  
  class Mystery < Type
  end

end
