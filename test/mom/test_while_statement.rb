
require_relative "helper"

module Mom
  class TestWhileConditionMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method_flat( "while(@a == 5) ; 5.mod4 ; end")
      @first = @stats.next.next
    end

    def test_if_compiles
      assert IfStatement != @stats.class , @stats
    end
    def test_check
      assert_equal TruthCheck , @first.class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @first.condition.class , @first
    end
    def test_length
      assert_equal 4 , @stats.length
    end
  end
end
