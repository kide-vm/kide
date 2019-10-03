require_relative "helper"

module Sol
  class TestSolMethod < MiniTest::Test
    include SolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_main("a = 5") )
      @clazz = ruby_tree.to_sol
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
      assert_equal Parfait::Class , @clazz.to_parfait.class
    end
    def test_method
      clazz =  @clazz.to_parfait
      assert_equal Parfait::SolMethod , clazz.get_instance_method(:main).class
    end
    def test_type_method
      clazz =  @clazz.to_parfait
      assert_equal Parfait::CallableMethod , clazz.instance_type.get_method(:main).class
    end
  end
end
