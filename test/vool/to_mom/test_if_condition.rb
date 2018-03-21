
require_relative "helper"

module Vool
  class TestConditionIfMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "if(5.mod4) ; @a = 6 ; else; @a = 5 ; end")
    end

    def test_condition
      assert_equal TruthCheck , @ins.next(4).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(4).condition.class , @ins
    end
    def test_hoisted_dynamic_call
      assert_equal SimpleCall , @ins.next(2).class
      assert_equal :mod4 , @ins.next(2).method.name
    end
    def test_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, TruthCheck, Label ,
                    SlotLoad, Jump, Label, SlotLoad, Label] , @ins
    end

  end
end
