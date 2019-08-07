
require_relative "helper"

module Vool
  class TestWhileConditionMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc::Builtin.boot_functions
      @compiler = compile_first_method( "while(5.div4) ; 5.div4 ; end")
      @ins = @compiler.mom_instructions.next
    end

    def pest_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next(5).class
    end
    def pest_condition_is_slot
      assert_equal SlotDefinition , @ins.next(5).condition.class , @ins
    end
    def pest_hoisetd
      jump = @ins.next(9)
      assert_kind_of Jump , jump
      assert jump.label.name.start_with?("cond_label") , jump.label.name
    end
    def pest_label
      label = @ins
      assert_equal Label , label.class
      assert label.name.start_with?("cond_label") , label.name
    end
    def pest_array
      check_array [Label, MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad ,
                    TruthCheck, MessageSetup, ArgumentTransfer, SimpleCall, Jump ,
                    Label] , @ins
    end

  end
end
