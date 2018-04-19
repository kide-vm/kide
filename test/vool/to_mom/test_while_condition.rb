
require_relative "helper"

module Vool
  class TestWhileConditionMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "while(5.div4) ; 5.div4 ; end")
    end

    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next(5).class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next(5).condition.class , @ins
    end
    def test_hoisetd
      assert_equal MessageSetup , @ins.class
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall,SlotLoad,Label,TruthCheck,MessageSetup,ArgumentTransfer,SimpleCall,Jump,Label] , @ins
    end

  end
end
