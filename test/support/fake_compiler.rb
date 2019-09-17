module Risc
  class FakeCallable
    def self_type
      Parfait.object_space.types.values.first
    end
    def name
      :fake_name
    end
  end
  class FakeCompiler
    attr_reader :instructions
    def initialize
      @instructions = []
    end
    def add_code(c)
      @instructions << c
    end
    def current
      @instructions.last
    end
    def slot_type(slot,type)
      type.type_for(slot)
    end
    def resolve_type(name)
      Parfait.object_space.types.values.first
    end
    def use_reg(type , extra = {})
      RegisterValue.new(:r1 , type)
    end
    def reset_regs
    end
    def add_constant(c)
    end
  end
end
