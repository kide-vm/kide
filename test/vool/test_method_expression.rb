require_relative "helper"

module Vool
  class TestMethodExpression < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_main("a = 5") )
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
    def test_fail
      assert_raises{ method.to_parfait }
    end
    def test_method
      assert_equal Parfait::Class , @clazz.to_parfait.class
    end
    def test_creates_instance_method
      main = @clazz.to_parfait.get_instance_method(:main)
      assert_equal Parfait::VoolMethod , main.class
      assert_equal :main , main.name
    end
    def test_creates_type_method
      clazz = @clazz.to_parfait
      m = clazz.instance_type.get_method(:main)
      assert m , "no type method :main"
    end

  end
  class TestMethodExpressionDoubleDef < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_main("a = 5") + ";" + as_main("a = 5") )
      @clazz = ruby_tree.to_vool
    end
    def method
      @clazz.body.first
    end
    def test_no_double
      assert_raises {@clazz.to_parfait}
    end
  end
end
