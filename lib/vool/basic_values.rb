module Vool
  class Constant < Expression
    #gobble it up
    def each(&block)
    end
  end

  class IntegerConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def slot_definition(compiler)
      return Mom::SlotDefinition.new(Mom::IntegerConstant.new(@value) , [])
    end
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Integer)
    end
    def to_s
      value.to_s
    end
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
      Parfait.object_space.get_type_by_class_name(:True)
    end
    def slot_definition(compiler)
      return Mom::SlotDefinition.new(Parfait.object_space.true_object , [])
    end
    def to_s(depth = 0)
      "true"
    end
  end
  class FalseConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:False)
    end
    def slot_definition(compiler)
      return Mom::SlotDefinition.new(Parfait.object_space.false_object , [])
    end
    def to_s(depth = 0)
      "false"
    end
  end
  class NilConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Nil)
    end
    def slot_definition(compiler)
      return Mom::SlotDefinition.new(Parfait.object_space.nil_object , [])
    end
    def to_s(depth = 0)
      "nil"
    end
  end
  class SelfExpression < Expression
    attr_reader :my_type
    def initialize(type = nil)
      @my_type = type
    end
    def slot_definition(compiler)
      @my_type = compiler.receiver_type
      Mom::SlotDefinition.new(:message , [:receiver])
    end
    def ct_type
      @my_type
    end
    def to_s(depth = 0)
      "self"
    end
  end
  class SuperExpression < Statement
    def to_s(depth = 0)
      "super"
    end
  end
  class StringConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def slot_definition(compiler)
      return Mom::SlotDefinition.new(Mom::StringConstant.new(@value),[])
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
