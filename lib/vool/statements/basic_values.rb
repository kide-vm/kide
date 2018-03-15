module Vool
  class Constant < Expression

  end

  class IntegerConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def slot_definition(method)
      return Mom::IntegerConstant.new(@value)
    end
    def ct_type
      Parfait.object_space.get_class_by_name(:Integer).instance_type
    end
    #gobble it up
    def each(&block)
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
  class SelfExpression < Expression
    attr_reader :clazz
    def to_mom(in_method)
      @clazz = in_method.clazz
      Mom::SlotDefinition.new(:message , [:receiver])
    end
    def ct_type
      @clazz.instance_type
    end
  end
  class SuperExpression < Statement
  end
  class StringConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def slot_definition(method)
      return Mom::StringConstant.new(@value)
    end
    def ct_type
      Parfait.object_space.get_class_by_name(:Word).instance_type
    end
  end
  class SymbolConstant < StringConstant
    def ct_type
      Parfait.object_space.get_class_by_name(:Word).instance_type
    end
  end
end
