require_relative "helper"

module Melon
  class TestClass < MiniTest::Test

    def setup
      Register.machine.boot
    end

    def test_creates_class_without_deriviation
      Compiler.compile "class Testing ; end"
      clazz = Parfait.object_space.get_class_by_name(:Testing)
      assert clazz , "No classes created"
      assert_equal :Object , clazz.super_class_name
    end

    def test_creates_class_with_deriviation
      Compiler.compile  "class Test2 < List ;end"
      clazz = Parfait.object_space.get_class_by_name(:Test2)
      assert clazz, "No classes created"
      assert_equal :List , clazz.super_class_name
    end

  end
end
