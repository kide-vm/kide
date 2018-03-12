require_relative "helper"

module Mom
  class TestDynamicCall < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method_flat( "a = 5; a.mod4")
      @first = @stats.next
    end

    def test_if_compiles
      assert_equal  @stats.last.class , DynamicCall , @stats
    end
    def test_check
      assert_equal NotSameCheck , @first.class
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @first.left.class , @first
    end
    def test_length
      assert_equal 12 , @stats.length
    end
    def test_array
      check_array [SlotConstant,NotSameCheck,Label,SlotMove,MessageSetup,ArgumentTransfer,SimpleCall,SlotMove,Label,MessageSetup,ArgumentTransfer,DynamicCall] , @stats
    end
  end
end
