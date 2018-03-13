module Mom
  # just name scoping the same stuff to mom
  # so we know we are on the way down, keeping our layers seperated
  # and we can put constant adding into the to_risc methods (instead of on vool classes)
  class Constant
  end

  class IntegerConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      Parfait.object_space.get_class_by_name(:Integer).instance_type
    end
  end
  class FloatConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      true
    end
  end
  class TrueConstant < Constant
    def ct_type
      Parfait.object_space.get_class_by_name(:True).instance_type
    end
  end
  class FalseConstant < Constant
    def ct_type
      Parfait.object_space.get_class_by_name(:False).instance_type
    end
  end
  class NilConstant < Constant
    def ct_type
      Parfait.object_space.get_class_by_name(:Nil).instance_type
    end
  end
  class StringConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      Parfait.object_space.get_class_by_name(:Word).instance_type
    end
  end
  class SymbolConstant < String
    def ct_type
      Parfait.object_space.get_class_by_name(:Word).instance_type
    end
  end
end
