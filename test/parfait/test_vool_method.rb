require_relative "helper"

module Vool
  class TestVoolMethod < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_test_main("a = 5") )
      @clazz = ruby_tree.to_vool
    end
    def method
      @clazz.body.first
    end
    def test_setup
      assert_equal ClassExpression , @clazz.class
      assert_equal Statements , @clazz.body.class
      assert_equal MethodExpression , method.class
    end
    def test_class
      assert_equal Parfait::Class , @clazz.create_class_object.class
    end
    def test_method
      clazz =  @clazz.create_class_object
      assert_equal Parfait::VoolMethod , method.make_method(clazz).class
    end
  end
end
