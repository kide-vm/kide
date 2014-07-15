require_relative "value"

module Virtual
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Mystery Type has unknown type and has only casting methods. So it must be cast to be useful.
  class Type
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
  end
  
  class Integer < Type

    def initialize
    end

  end
  
  class Reference < Type

    def initialize clazz = nil
      @clazz = clazz
    end
    attr_accessor :clazz
    def attributes
      [:clazz]
    end
    def at_index block , left , right
      block.ldr( self , left , right )
      self
    end
  end
  
  class SelfReference < Reference
  end

  class Mystery < Type
    def initialize 
    end

    def as type
      type.new
    end

  end

end
