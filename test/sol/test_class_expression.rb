
require_relative "helper"

module Sol
  class TestClassStatement < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_test_main("@a = 5") )
      @sol = ruby_tree.to_sol
    end
    def test_class
      assert_equal ClassExpression , @sol.class
      assert_equal :Test , @sol.name
    end
    def test_method
      assert_equal MethodExpression , @sol.body.first.class
    end
    def test_create_class
      assert_equal Parfait::Class , @sol.create_class_object.class
    end
    def test_create_class
      assert_equal :Test , @sol.to_parfait.name
    end
    def test_class_instance
      assert_equal :a , @sol.to_parfait.instance_type.names[1]
    end
    def test_to_s
      assert_tos "class Test < Object;def main(arg);@a = 5;return @a;end;end" , @sol
    end
  end
  class TestClassStatementTypeCreation < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def check_type_for(input)
      ruby_tree = Ruby::RubyCompiler.compile( as_test_main(input) )
      sol = ruby_tree.to_sol
      assert_equal ClassExpression , sol.class
      clazz = sol.to_parfait
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
      sol_tree = Ruby::RubyCompiler.compile( space_test).to_sol
      assert_raises {sol_tree.to_parfait}
    end
  end
end
