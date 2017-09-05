
require_relative "helper"

module Vool
  class TestWhileConditionMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "while(@a == 5) ; 5.mod4 ; end")
      @first = @stats.first
    end

    def test_if_compiles_as_array
      assert_equal Mom::WhileStatement , @first.class , @stats
    end
    def test_condition_compiles_to_slot
      assert_equal Mom::TruthCheck , @first.condition.class
    end
    def test_condition_is_slot
      assert_equal Mom::SlotDefinition , @first.condition.condition.class , @stats
    end
    def test_hoisetd
      assert_equal Mom::SlotConstant , @first.hoisted.class
    end
  end
end
