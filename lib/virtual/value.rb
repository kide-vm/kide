module Virtual
  
  # the virtual machine is implemented in values (a c++ version of oo). 
  # Values have types which are represented as classes, instances of Type to be precise

  # Values must really be Constants or Variables, ie have a storage space

  class Value
    def == other
      other.class == self.class
    end
    def inspect
      self.class.name + ".new()"
    end
    def type
      raise "abstract called"
    end
    private
    def initialize
    end
  end
  
end