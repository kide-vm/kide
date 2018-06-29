require_relative "helper"

module RubyX
  class TestVoolCompiler < MiniTest::Test
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

    def test_doesnt_create_existing_clas
      space_class = Parfait.object_space.get_class_by_name(:Space)
      ruby_to_vool "class Space ; end"
      clazz = Parfait.object_space.get_class_by_name(:Space)
      assert_equal clazz , space_class
    end

    def test_class_body_is_scope
      clazz = ruby_to_vool in_Test("def meth; @ivar = 5 ;end")
      assert_equal Vool::Statements , clazz.body.class
      assert_equal Vool::MethodStatement , clazz.body.first.class
    end

    def test_space_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space)
      ruby_to_vool  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space)
      assert_equal space1 , space2
    end

    def test_space_type_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space).instance_type
      ruby_to_vool  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space).instance_type
      assert_equal space1 , space2
    end

  end
end
