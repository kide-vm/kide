
require_relative "helper"

module Vool
  class TestClassStatement < MiniTest::Test
    include ScopeHelper
    def setup
      Parfait.boot!({})
      ruby_tree = Ruby::RubyCompiler.compile( as_test_main("a = 5") )
      @vool = ruby_tree.to_vool
    end
    def test_class
      assert_equal ClassStatement , @vool.class
    end
    def test_method
      assert_equal MethodStatement , @vool.body.first.class
    end
    def test_create_class
      assert_equal Parfait::Class , @vool.create_class_object.class
    end
    def test_create_class
      assert_equal :Test , @vool.create_class_object.name
    end
  end
  class TestClassStatementCompile < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_first_method( "if(@a) ; @a = 5 ; else; @a = 6 ; end")
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
                    Label, SlotLoad, Label, Label, ReturnSequence ,
                    Label] , @ins
    end
  end
end
