require_relative "helper"

module Ruby
  class ModuleNameTest < Minitest::Test
    include RubyTests

    def test_parfait_module
      assert_equal [nil],  compile("module Parfait ; end")
    end
    def test_parfait_module_const
      assert_equal IntegerConstant,  compile("module Parfait ; 1;end").first.class
    end

    def test_module_parfait_removed
      exp = compile( "::Parfait::Object" )
      assert_equal ModuleName , exp.class
      assert_equal :Object , exp.name
    end

  end
end
