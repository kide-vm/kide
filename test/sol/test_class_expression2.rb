
require_relative "helper"

module Sol
  class TestClassStatementCompile < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "if(@a) ; @a = 5 ; else; @a = 6 ; end; return")
      @ins = @compiler.slot_instructions
    end

    def test_label
      assert_equal Label , @ins.class , @ins
      assert_equal "Space_Type.main" , @ins.name , @ins
    end
    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlottedMessage , @ins.next.condition.class , @ins
    end
    def test_label_after_check
      assert_equal Label , @ins.next(2).class , @ins
    end
    def test_label_last
      assert_equal Label , @ins.last.class , @ins
    end
    def test_array
      check_array [Label, TruthCheck, Label, SlotLoad, Jump ,
                    Label, SlotLoad, Label, SlotLoad, ReturnJump ,
                    Label, ReturnSequence, Label]  , @ins
    end
  end
end
