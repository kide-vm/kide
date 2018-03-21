
require_relative "helper"

module Vool
  class TestConditionIfMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "if(@a == 5) ; 5.mod4 ; else; 4.mod4 ; end")
    end

    def test_condition
      assert_equal TruthCheck , @ins.next(11).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(11).condition.class , @ins
    end
    def test_hoisted_dynamic_call
      assert_equal DynamicCall , @ins.next(9).class
    end
    def test_array
      check_array [NotSameCheck, SlotLoad, MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad ,
                    Label, MessageSetup, ArgumentTransfer, DynamicCall, SlotLoad, TruthCheck ,
                    Label, MessageSetup, ArgumentTransfer, SimpleCall, Jump, Label ,
                    MessageSetup, ArgumentTransfer, SimpleCall, Label] , @ins
    end

  end
end
