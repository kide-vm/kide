
require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_test_main("@a = 5") )
      @vool = ruby_tree.to_vool
    end
    def test_class
      assert_equal ClassExpression , @vool.class
      assert_equal :Test , @vool.name
    end
    def test_method
      assert_equal MethodExpression , @vool.body.first.class
    end
    def test_create_class
      assert_equal Parfait::Class , @vool.create_class_object.class
    end
    def test_create_class
      assert_equal :Test , @vool.to_parfait.name
    end
    def test_class_instance
      assert_equal :a , @vool.to_parfait.instance_type.names[1]
    end
  end
  class TestClassStatementTypeCreation < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def check_type_for(input)
      ruby_tree = Ruby::RubyCompiler.compile( as_test_main(input) )
      vool = ruby_tree.to_vool
      assert_equal ClassExpression , vool.class
      clazz = vool.to_parfait
      assert_equal Parfait::Class , clazz.class
      assert_equal :a , clazz.instance_type.names[1]
    end
    def test_while_cond
      check_type_for("while(@a) ; 1 == 1 ; end")
    end
    def test_while_cond_eq
      check_type_for("while(@a==1); 1 == 1 ; end")
    end
    def test_if_cond
      check_type_for("if(@a); 1 == 1 ; end")
    end
    def test_send_1
      check_type_for("@a.call")
    end
    def test_send_arg
      check_type_for("call(@a)")
    end
    def test_return
      check_type_for("return @a")
    end
    def test_return_call
      check_type_for("return call(@a)")
    end
    def test_return_rec
      check_type_for("return @a.call()")
    end
  end
  class TestClassSuperMismatch < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def space_test
      as_test_main("return 1") + ";class Test < Space ; def main();return 1;end;end"
    end
    def test_mismatch
      vool_tree = Ruby::RubyCompiler.compile( space_test).to_vool
      assert_raises {vool_tree.to_parfait}
    end
  end
end
