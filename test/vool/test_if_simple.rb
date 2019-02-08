
require_relative "helper"

module Vool
  class TestSimpleIfMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @ins = compile_first_method( "if(@a) ; @a = 5 ; else; @a = 6 ; end")
    end

    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.condition.class , @ins
    end
    def test_label_after_check
      assert_equal Label , @ins.next.class , @ins
    end
    def test_label_last
      assert_equal Label , @ins.last.class , @ins
    end
    def test_array
      check_array [TruthCheck, Label, SlotLoad, Jump, Label, SlotLoad ,
                   Label] , @ins
    end
  end
end
