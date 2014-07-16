module Virtual
  
  # the virtual machine is implemented in values (a c++ version of oo). 
  # Values have types which are represented as classes, instances of Type to be precise

  # Values must really be Constants or Variables, ie have a storage space

  class Value
    def == other
      other.class == self.class
    end
    def type
      raise "abstract called for #{self.class}"
    end
    def attributes
      raise "abstract called for #{self.class}"
    end
    def == other
      return false unless other.class == self.class 
      attributes.each do |a|
        left = send(a)
        right = other.send(a)
        return false unless left.class == right.class 
        return false unless left == right
      end
      return true
    end
    def inspect
      self.class.name + ".new(" + attributes.collect{|a| send(a).inspect }.join(",")+ ")"
    end
    private
    def initialize
    end
  end

  class Variable < Value

    def initialize name , type
      @name = name.to_sym
      @type = type
    end
    attr_accessor :name , :type
    def attributes
      [:name , :type]
    end
  end
  # The subclasses are not strictly speaking neccessary at this def point
  # i just don't want to destroy the information for later optimizations
  # 
  # All variables are stored in frames and quite possibly in order arg,local,tmp
  class Return < Variable
    def initialize type
      super(:return , type)
    end
    def attributes
      [:type]
    end
  end
  class Self < Variable
    def initialize type
      super(:self , type)
    end
    def attributes
      [:type]
    end
  end
  class Argument < Variable
  end
  class Local < Variable
  end
  class Temp < Variable
  end
end