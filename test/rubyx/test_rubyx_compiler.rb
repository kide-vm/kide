require_relative "helper"

module RubyX
  class TestRubyXCompiler < MiniTest::Test
    include ScopeHelper
    include RubyXHelper

    def test_compile_class_one
      itest = compile_in_test "def meth; @ivar = 5; end"
      assert itest.instance_type.names.include?(:ivar) , itest.instance_type.names.inspect
    end

    def test_compile_class_two
      itest = compile_in_test "def meth; @ivar = 5; end;def meth2(arg); @trivar = 5; end"
      assert itest.instance_type.names.include?(:trivar) , itest.instance_type.names.inspect
    end

    def test_class_body_is_scope
      clazz = ruby_to_sol in_Test("def meth; @ivar = 5 ;end")
      assert_equal Sol::Statements , clazz.body.class
      assert_equal Sol::MethodExpression , clazz.body.first.class
    end

    def test_space_is_unchanged_by_compile
      compiler = RubyXCompiler.new(RubyX.default_test_options)
      space1 = Parfait.object_space.get_class_by_name(:Space)
      compiler.ruby_to_sol  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space)
      assert_equal space1 , space2
    end

    def test_space_type_is_unchanged_by_compile
      compiler = RubyXCompiler.new(RubyX.default_test_options)
      space1 = Parfait.object_space.get_type_by_class_name(:Space)
      compiler.ruby_to_sol  "class Space ;end"
      space2 = Parfait.object_space.get_type_by_class_name(:Space)
      assert_equal space1 , space2
    end

  end
end
