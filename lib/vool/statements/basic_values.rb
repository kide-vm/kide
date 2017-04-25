module Vool
  class IntegerStatement < Statement
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      Parfait.object_space.get_class_by_name(:Integer).instance_type
    end
  end
  class FloatStatement < Statement
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      true
    end
  end
  class TrueStatement < Statement
    def ct_type
      Parfait.object_space.get_class_by_name(:True).instance_type
    end
  end
  class FalseStatement < Statement
    def ct_type
      Parfait.object_space.get_class_by_name(:False).instance_type
    end
  end
  class NilStatement < Statement
    def ct_type
      Parfait.object_space.get_class_by_name(:Nil).instance_type
    end
  end
  class SelfStatement < Statement
    attr_reader :clazz

    def set_class(clazz)
      @clazz = clazz
    end
    def ct_type
      @clazz.instance_type
    end
  end
  class SuperStatement < Statement
  end
  class StringStatement < Statement
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      Parfait.object_space.get_class_by_name(:Word).instance_type
    end
  end
  class SymbolStatement < StringStatement
    def ct_type
      Parfait.object_space.get_class_by_name(:Word).instance_type
    end
  end
end
