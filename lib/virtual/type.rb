require_relative "value"

module Virtual
  # Integer and (Object) References are the main derived classes, but float will come and ...
  # The Mystery Type has unknown type and has only casting methods. So it must be cast to be useful.
  class Type
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
