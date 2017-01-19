require_relative "helper"

module Rubyx
  class TestCompiler < MiniTest::Test

    def setup
      Risc.machine.boot
    end

    def test_doesnt_create_existing_clas
      space_class = Parfait.object_space.get_class_by_name(:Space)
      RubyCompiler.compile "class Space ; end"
      clazz = Parfait.object_space.get_class_by_name(:Space)
      assert_equal clazz , space_class
    end

    def test_creates_class_without_deriviation
      RubyCompiler.compile "class Testing ; end"
      clazz = Parfait.object_space.get_class_by_name(:Testing)
      assert clazz , "No classes created"
      assert_equal :Object , clazz.super_class_name
    end

    def test_creates_class_with_deriviation
      RubyCompiler.compile  "class Test2 < List ;end"
      clazz = Parfait.object_space.get_class_by_name(:Test2)
      assert clazz, "No classes created"
      assert_equal :List , clazz.super_class_name
    end

    def test_space_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space)
      RubyCompiler.compile  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space)
      assert_equal space1 , space2
    end

    def test_space_type_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space).instance_type
      RubyCompiler.compile  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space).instance_type
      assert_equal space1 , space2
    end

  end
end
