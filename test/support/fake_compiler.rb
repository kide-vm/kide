module Risc
  module HasCompiler
    def risc(i)
      assert @compiler , "no compiler"
      instructions = @compiler.risc_instructions
      return instructions if i == 0
      instructions.next(i)
    end
  end
  class FakeCallable
    def self_type
      Parfait.object_space.types.values.first
    end
    def name
      :fake_name
    end
  end
  def self.test_compiler(label =  SlotMachine::Label.new("start","start_label"))
    CallableCompiler.new( FakeCallable.new , label)
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
    def reset_regs
    end
    def add_constant(c)
    end
  end
  class RegisterValue
    def is_object?
      @symbol.to_s.start_with?("id_")
    end
  end
end
