require_relative "helper"

module Vool
  class TestClassMethodExpression < MiniTest::Test
    include VoolCompile

    def class_code
      "class Space;def self.meth; return meth(22 + 22) ; end;end"
    end
    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( class_code )
      @clazz = ruby_tree.to_vool
    end
    def method
      @clazz.body.first
    end
    def test_setup
      assert_equal ClassExpression , @clazz.class
      assert_equal Statements , @clazz.body.class
      assert_equal ClassMethodExpression , method.class
    end
    def test_fail
      assert_raises{ method.to_parfait }
    end
    def test_creates_class_method
      clazz = @clazz.to_parfait
      m = clazz.single_class.get_instance_method(:meth)
      assert m , "no method :meth"
    end
    def test_creates_type_method
      clazz = @clazz.to_parfait
      m = clazz.single_class.instance_type.get_method(:meth)
      assert m , "no type method :meth"
    end
    def as_mom
      @clazz.to_parfait
      @clazz.to_mom(nil)
    end
    def test_mom
      assert_equal :meth , as_mom.method_compilers.callable.name
    end
    def test_mom_frame
      callable = as_mom.method_compilers.callable
      assert callable.frame_type.names.last.to_s.start_with?("tmp_") , "no tmp_ variable #{callable.frame_type.names}"
    end
  end
end
