
require_relative "helper"

module Vool
  class TestSimpleIfMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "if(@a) ; 5.mod4 ; else; 4.mod4 ; end")
      @first = @stats.first
    end

    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_if_compiles_as_array
      assert_equal Mom::IfStatement , @first.class , @stats
    end
    def test_condition_compiles_to_check
      assert_equal Mom::TruthCheck , @first.condition.class , @stats
    end
    def test_condition_is_slot
      assert_equal Mom::SlotDefinition , @first.condition.condition.class , @stats
    end
    def test_nothing_hoisted
      assert_nil @first.hoisted , @stats
    end
    def test_array
      check_array [SlotLoad,TruthCheck,Label,MessageSetup,ArgumentTransfer,SimpleCall,Label], @stats
    end
  end
end
