
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
      assert_equal Array , @first.class , @stats
    end
    def test_if_compiles_as_array_2
      assert_equal 5 , @first.length , @stats
    end
    def test_condition_compiles_to_slot
      assert_equal Mom::SlotConstant , @first.first.class
    end
    def test_condition_compiles_to_check_second
      assert_equal Mom::TruthCheck , @first[1].class
    end
    def test_condition_is_send
      assert_equal Vool::LocalVariable , @first[1].condition.class
    end
  end
end
