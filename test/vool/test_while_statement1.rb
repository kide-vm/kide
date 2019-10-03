
require_relative "helper"

module Vool
  class TestWhileConditionSlotMachine < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_main( "while(5.div4) ; 5.div4 ; end;return" , "Integer.div4")
      @ins = @compiler.slot_instructions.next
    end

    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next(4).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(4).condition.class , @ins
    end
    def test_hoisetd
      jump = @ins.next(8)
      assert_kind_of Jump , jump
      assert jump.label.name.start_with?("cond_label") , jump.label.name
    end
    def test_label
      label = @ins
      assert_equal Label , label.class
      assert label.name.start_with?("cond_label") , label.name
    end
    def test_array
      check_array [Label, MessageSetup, ArgumentTransfer, SimpleCall, TruthCheck ,
                    MessageSetup, ArgumentTransfer, SimpleCall, Jump, Label ,
                    SlotLoad, ReturnJump,Label, ReturnSequence, Label ,Label ,
                    ReturnSequence, Label] , @ins
    end

  end
end
