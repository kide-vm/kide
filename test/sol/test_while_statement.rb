require_relative "helper"

module Sol
  class TestSimpleWhileSlotMachine < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "while(@a) ; @a = 5 ; end;return")
      @ins = @compiler.slot_instructions.next
    end

    def test_compiles_as_while
      assert_equal Label , @ins.class , @ins
    end
    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next.class , @ins
    end
    def test_condition_is_slot
      assert_equal MessageSlot , @ins.next.condition.class , @ins
    end
    def test_array
      check_array [Label, TruthCheck, SlotLoad, Jump, Label ,
                    SlotLoad, ReturnJump,Label, ReturnSequence, Label], @ins
    end
  end
end
