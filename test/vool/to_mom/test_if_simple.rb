
require_relative "helper"

module Vool
  class TestSimpleIfMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "if(@a) ; 5.mod4 ; else; 4.mod4 ; end")
    end

    def test_compiles_not_array
      assert Array != @ins.class , @ins
    end
    def test_if_compiles_as_array
      assert_equal Mom::IfStatement , @ins.class , @ins
    end
    def test_condition_compiles_to_check
      assert_equal Mom::TruthCheck , @ins.condition.class , @ins
    end
    def test_condition_is_slot
      assert_equal Mom::SlotDefinition , @ins.condition.condition.class , @ins
    end
    def test_nothing_hoisted
      assert_nil @ins.hoisted , @ins
    end
    def test_array
      check_array [SlotLoad,TruthCheck,Label,MessageSetup,ArgumentTransfer,SimpleCall,Label], @ins
    end
  end
end
