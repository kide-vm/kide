module Sol
  #Marker class for different constants
  class Constant < Expression
  end

  # An integer at the sol level
  class IntegerConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def to_slotted(_)
      return SlotMachine::Slotted.for(SlotMachine::IntegerConstant.new(@value) )
    end
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Integer)
    end
    def to_s(depth = 0)
      value.to_s
    end
  end
  # An float at the sol level
  class FloatConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def ct_type
      true
    end
    def to_s(depth = 0)
      value.to_s
    end
  end
  # True at the sol level
  class TrueConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:True)
    end
    def to_slotted(_)
      return SlotMachine::Slotted.for(Parfait.object_space.true_object )
    end
    def to_s(depth = 0)
      "true"
    end
  end
  # False at the sol level
  class FalseConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:False)
    end
    def to_slotted(_)
      return SlotMachine::Slotted.for(Parfait.object_space.false_object )
    end
    def to_s(depth = 0)
      "false"
    end
  end
  # Nil at the sol level
  class NilConstant < Constant
    def ct_type
      Parfait.object_space.get_type_by_class_name(:Nil)
    end
    def to_slotted(_)
      return SlotMachine::Slotted.for(Parfait.object_space.nil_object )
    end
    def to_s(depth = 0)
      "nil"
    end
  end

  # Self at the sol level
  class SelfExpression < Expression
    attr_reader :my_type
    def initialize(type = nil)
      @my_type = type
    end
    def to_slotted(compiler)
      @my_type = compiler.receiver_type
      SlotMachine::Slotted.for(:message , [:receiver])
    end
    def ct_type
      @my_type
    end
    def to_s(depth = 0)
      "self"
    end
  end
  class StringConstant < Constant
    attr_reader :value
    def initialize(value)
      @value = value
    end
    def to_slotted(_)
      return SlotMachine::Slotted.for(SlotMachine::StringConstant.new(@value))
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
    def to_s(depth = 0)
      ":#{@value}"
    end
  end
end
