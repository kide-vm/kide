module Risc
  class FakeCompiler
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
