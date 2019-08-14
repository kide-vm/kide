require_relative "helper"

module Vool
  class TestConditionIfMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = compile_first_method( "if(5.div4) ; @a = 6 ; else; @a = 5 ; end")
      @ins = @compiler.mom_instructions.next
    end

    def test_condition
      assert_equal TruthCheck , @ins.next(4).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(4).condition.class , @ins
    end
    def test_hoisted_dynamic_call
      assert_equal SimpleCall , @ins.next(2).class
      assert_equal :div4 , @ins.next(2).method.name
    end
    def test_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, TruthCheck,
                  Label ,SlotLoad, Jump, Label, SlotLoad, Label,
                  Label, ReturnSequence, Label ] , @ins
    end

  end
end
