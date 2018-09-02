require_relative "helper"

module RubyX
  class TestRubyXCompilerMom < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def test_creates_class_without_deriviation
      ruby_to_mom "class Testing ; end"
      clazz = Parfait.object_space.get_class_by_name(:Testing)
      assert clazz , "No classes created"
      assert_equal :Object , clazz.super_class_name
    end

    def test_creates_class_deriviation
      mom = ruby_to_mom "class Testing ; end"
      assert mom , "No classes created"
    end

    def test_creates_class_with_deriviation
      ruby_to_mom  "class Test2 < List ;end"
      clazz = Parfait.object_space.get_class_by_name(:Test2)
      assert clazz, "No classes created"
      assert_equal :List , clazz.super_class_name
    end

    def test_space_type_is_unchanged_by_compile
      compiler = RubyXCompiler.new
      space1 = Parfait.object_space.get_type_by_class_name(:Space)
      compiler.ruby_to_vool  "class Space ;end"
      space2 = Parfait.object_space.get_type_by_class_name(:Space)
      assert_equal space1 , space2
    end

  end
end
