
require_relative "helper"

module Mom
  class TestConditionIfMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method_flat( "if(@a == 5)  ; 5.mod4 ; else; 4.mod4 ; end")
      @first = @stats.next
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
      assert_equal 9 , @stats.length
    end
    def test_array
      check_array [SlotMove,TruthCheck,Label,SimpleCall,SlotConstant,Label,SimpleCall,SlotConstant,Label] , @stats
    end
  end
end
