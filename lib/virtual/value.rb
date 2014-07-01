module Virtual
  
  # the virtual machine is implemented in values. Values have types which are represented as classes, but it is still
  # important to make the distinction. Values are immutable, passed by value and machine word sized.
  
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Mystery Value has unknown type and has only casting methods. So it must be cast to be useful.
  class Value
    def == other
      other.class == self.class
    end
    def inspect
      self.class.name + ".new()"
    end
    def type
      self.class
    end
    private
    def initialize
    end
  end
end