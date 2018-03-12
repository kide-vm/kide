require_relative "helper"

module Vool
  class TestClassCompiler < MiniTest::Test
    include CompilerHelper

    def setup
      Risc.machine.boot
    end

    def compile_in_test input
      VoolCompiler.ruby_to_vool in_Test(input)
      itest = Parfait.object_space.get_class_by_name(:Test)
      assert itest
      itest
    end

    def test_compile_class_one
      itest = compile_in_test "def meth; @ivar; end"
      assert itest.instance_type.names.include?(:ivar) , itest.instance_type.names.inspect
    end

    def test_compile_class_two
      itest = compile_in_test "def meth; @ivar; end;def meth2(arg); @trivar = 5; end"
      assert itest.instance_type.names.include?(:trivar) , itest.instance_type.names.inspect
    end

    def test_doesnt_create_existing_clas
      space_class = Parfait.object_space.get_class_by_name(:Space)
      VoolCompiler.ruby_to_vool "class Space ; end"
      clazz = Parfait.object_space.get_class_by_name(:Space)
      assert_equal clazz , space_class
    end

    def test_class_body_is_scope
      clazz = VoolCompiler.ruby_to_vool in_Test("def meth; @ivar ;end")
      assert_equal ScopeStatement , clazz.body.class
    end

    def test_creates_class_without_deriviation
      VoolCompiler.ruby_to_vool "class Testing ; end"
      clazz = Parfait.object_space.get_class_by_name(:Testing)
      assert clazz , "No classes created"
      assert_equal :Object , clazz.super_class_name
    end

    def test_creates_class_with_deriviation
      VoolCompiler.ruby_to_vool  "class Test2 < List ;end"
      clazz = Parfait.object_space.get_class_by_name(:Test2)
      assert clazz, "No classes created"
      assert_equal :List , clazz.super_class_name
    end

    def test_space_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space)
      VoolCompiler.ruby_to_vool  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space)
      assert_equal space1 , space2
    end

    def test_space_type_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space).instance_type
      VoolCompiler.ruby_to_vool  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space).instance_type
      assert_equal space1 , space2
    end

  end
end
