
require_relative "helper"

module Vool
  class TestIfMom #< MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "if(@a == 5) ; 5.mod4 ; else; 4.mod4 ; end")
      @first = @stats.first
    end

    def test_if_compiles_as_array
      assert_equal Array , @first.class , @stats
    end
    def test_condition_compiles_to_check
      assert_equal Mom::TruthCheck , @first.first.class , @stats
    end
    def test_condition_is_instance
      assert_equal Vool::LocalVariable , @first.first.condition.class , @stats
    end
    def est_true_block_is_second
      assert_equal  @first[1] , @first.first.true_block , @stats
    end

  end
end
