module Ruby
  class Constant < Statement
    def to_vool
      vool_brother.new
    end
  end
  class ValueConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def to_vool
      vool_brother.new(@value)
    end
  end
  class IntegerConstant < ValueConstant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Integer)
    end
    def to_s
      value.to_s
    end
  end
  class FloatConstant < ValueConstant
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
      Parfait.object_space.get_type_by_class_name(:True)
    end
    def to_s(depth = 0)
      "true"
    end
  end
  class FalseConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:False)
    end
    def to_s(depth = 0)
      "false"
    end
  end
  class NilConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Nil)
    end
    def to_s(depth = 0)
      "nil"
    end
  end
  class SelfExpression < Constant
    def to_s(depth = 0)
      "self"
    end
  end
  class SuperExpression < Statement
    def to_s(depth = 0)
      "super"
    end
    def to_vool
      vool_brother.new
    end
  end
  class StringConstant < ValueConstant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Word)
    end
    def to_s(depth = 0)
      "'#{@value}'"
    end
  end
  class SymbolConstant < StringConstant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Word)
    end
  end
end
