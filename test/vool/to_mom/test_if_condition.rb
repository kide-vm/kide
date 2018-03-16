
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
      assert_equal TruthCheck , @ins.next(12).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(12).condition.class , @ins
    end
    def test_hoisted_dynamic_call
      assert_equal DynamicCall , @ins.next(10).class
    end
    def test_array
      check_array [NotSameCheck,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,DynamicCall,SlotLoad,TruthCheck,Label,MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,Jump,Label,MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,Label], @ins
    end

  end
end
