require_relative "../helper"

module RubyX
  class TestVoolCompiler < MiniTest::Test
    include ScopeHelper

    def setup
      Risc.machine.boot
    end
    def ruby_to_vool(input)
      RubyXCompiler.ruby_to_vool(input)
    end

    def test_creates_class_without_deriviation
      vool = ruby_to_vool "class Testing ; end"
      vool.to_mom(nil)
      clazz = Parfait.object_space.get_class_by_name(:Testing)
      assert clazz , "No classes created"
      assert_equal :Object , clazz.super_class_name
    end

    def test_creates_class_deriviation
      vool = ruby_to_vool "class Testing ; end"
      mom = vool.to_mom(nil)
      assert_equal Vool::ClassStatement , vool.class
      #assert mom , "No classes created"
    end

    def test_creates_class_with_deriviation
      vool = ruby_to_vool  "class Test2 < List ;end"
      vool.to_mom(nil)
      clazz = Parfait.object_space.get_class_by_name(:Test2)
      assert clazz, "No classes created"
      assert_equal :List , clazz.super_class_name
    end

    def test_space_type_is_unchanged_by_compile
      space1 = Parfait.object_space.get_class_by_name(:Space).instance_type
      ruby_to_vool  "class Space ;end"
      space2 = Parfait.object_space.get_class_by_name(:Space).instance_type
      assert_equal space1 , space2
    end

  end
end
