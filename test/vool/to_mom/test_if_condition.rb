
require_relative "helper"

module Vool
  class TestConditionIfMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "if(@a == 5) ; 5.mod4 ; else; 4.mod4 ; end")
      @first = @stats.first
    end

    def test_if_compiles_as_array
      assert_equal Mom::IfStatement , @first.class , @stats
    end
    def test_condition_compiles_to_slot
      assert_equal Mom::TruthCheck , @first.condition.class
    end
    def test_condition_is_slot
      assert_equal Mom::SlotDefinition , @first.condition.condition.class , @stats
    end
    def test_hoisetd
      assert_equal Mom::SlotLoad , @first.hoisted.class
    end
  end
end
