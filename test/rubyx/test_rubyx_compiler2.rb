require_relative "helper"

module RubyX
  class TestRubyXCompilerRisc < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def setup
      super
      code = "class Space ; def main(arg);return arg;end; end"
      @comp = RubyXCompiler.new(load_parfait: true )
      @collection = @comp.ruby_to_risc(code)
    end
    def test_to_risc
      assert_equal Risc::RiscCollection , @collection.class
    end
    def pest_linker
      assert_equal Risc::Linker , @collection.translate(:interpreter).class
    end
    def pest_method
      assert_equal :main , @linker.assemblers.first.callable.name
    end
    def pest_asm_len
      assert_equal 23 , @linker.assemblers.length
    end
  end
  class TestRubyXCompilerParfait < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def setup
      super
      code = "class Space ; def self.class_method; return 1; end;def main(arg);return Space.class_method;end; end"
      @comp = RubyXCompiler.ruby_to_binary(code , load_parfait: true , platform: :interpreter)
    end

    def pest_load
      object = Parfait.object_space.get_class_by_name(:Object)
      assert_equal Parfait::Class , object.class
      object = object.instance_type
      object.methods.each_method {|m| puts m.name}
      assert_equal Parfait::Type , object.get_method(:set_type)
    end
  end
end
