
require_relative "helper"

module Sol
  class TestIfNoIf < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "unless(@a) ; @a = 5 ; end;return")
      @ins = @compiler.slot_instructions.next
    end

    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlottedMessage , @ins.condition.class , @ins
    end
    def test_label_after_check
      assert_equal Label , @ins.next.class , @ins
    end
    def test_label_last
      assert_equal Label , @ins.last.class , @ins
    end
    def test_array
      check_array  [TruthCheck, Label, Jump, Label, SlotLoad ,
                    Label, SlotLoad, ReturnJump,Label, ReturnSequence, Label] , @ins
    end
  end
end
