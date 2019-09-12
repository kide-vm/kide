
require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
      ruby_tree = Ruby::RubyCompiler.compile( as_main("@a = 5") )
      @vool = ruby_tree.to_vool
    end
    def test_class
      assert_equal ClassExpression , @vool.class
    end
    def test_method
      assert_equal MethodExpression , @vool.body.first.class
    end
    def test_create_class
      assert_equal Parfait::Class , @vool.create_class_object.class
    end
    def test_create_class
      assert_equal :Test , @vool.create_class_object.name
    end
    def test_class_instance
      assert_equal :a , @vool.create_class_object.instance_type.names[1]
    end
  end
  class TestClassStatementTypeCreation < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!(Parfait.default_test_options)
    end
    def assert_type_for(input)
      ruby_tree = Ruby::RubyCompiler.compile( as_main(input) )
      vool = ruby_tree.to_vool
      assert_equal ClassExpression , vool.class
      clazz = vool.create_class_object
      assert_equal Parfait::Class , clazz.class
      assert_equal :a , clazz.instance_type.names[1]
    end
    def test_while_cond
      assert_type_for("while(@a) ; 1 == 1 ; end")
    end
    def test_while_cond_eq
      assert_type_for("while(@a==1); 1 == 1 ; end")
    end
    def test_if_cond
      assert_type_for("if(@a); 1 == 1 ; end")
    end
    def test_send_1
      assert_type_for("@a.call")
    end
    def test_send_arg
      assert_type_for("call(@a)")
    end
    def test_return
      assert_type_for("return @a")
    end
    def test_return_call
      assert_type_for("return call(@a)")
    end
    def test_return_rec
      assert_type_for("return @a.call()")
    end
  end
  class TestClassStatementCompile < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "if(@a) ; @a = 5 ; else; @a = 6 ; end; return")
      @ins = @compiler.mom_instructions
    end

    def test_label
      assert_equal Label , @ins.class , @ins
      assert_equal "Test_Type.main" , @ins.name , @ins
    end
    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next.condition.class , @ins
    end
    def test_label_after_check
      assert_equal Label , @ins.next(2).class , @ins
    end
    def test_label_last
      assert_equal Label , @ins.last.class , @ins
    end
    def test_array
      check_array [Label, TruthCheck, Label, SlotLoad, Jump ,
                    Label, SlotLoad, Label, SlotLoad, ReturnJump ,
                    Label, ReturnSequence, Label]  , @ins
    end
  end
end
