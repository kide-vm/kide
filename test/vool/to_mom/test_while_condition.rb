
require_relative "helper"

module Vool
  class TestWhileConditionMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Parfait.boot!
      Risc::Builtin.boot_functions
      @ins = compile_first_method( "while(5.div4) ; 5.div4 ; end")
    end

    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next(5).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(5).condition.class , @ins
    end
    def test_hoisetd
      jump = @ins.next(9)
      assert_kind_of Jump , jump
      assert jump.label.name.start_with?("cond_label") , jump.label.name
    end
    def test_label
      label = @ins
      assert_equal Label , label.class
      assert label.name.start_with?("cond_label") , label.name
    end
    def test_array
      check_array [Label, MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad ,
                    TruthCheck, MessageSetup, ArgumentTransfer, SimpleCall, Jump ,
                    Label] , @ins
    end

  end
end
