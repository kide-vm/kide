require_relative "helper"

module Ruby
  class ModuleNameTest < Minitest::Test
    include RubyTests

    def test_parfait_module_scoped
      lst = compile("module Parfait ;  1 ; 1 ; end")
      assert_equal ScopeStatement,  lst.class
      assert_equal IntegerConstant,  lst.first.class
      assert_equal 2,  lst.length
    end
    def test_parfait_module_const
      assert_equal IntegerConstant,  compile("module Parfait ; 1;end").class
    end

    def test_module_parfait_removed
      exp = compile( "::Parfait::Object" )
      assert_equal ModuleName , exp.class
      assert_equal :Object , exp.name
    end

  end
end
