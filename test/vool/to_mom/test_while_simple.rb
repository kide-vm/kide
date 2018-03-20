
require_relative "helper"

module Vool
  class TestSimpleWhileMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "while(@a) ; 5.mod4 ; end")
    end

    def test_compiles_as_while
      assert_equal Label , @ins.class , @ins
    end
    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next.condition.class , @ins
    end
    def test_array
      check_array [Label,TruthCheck,MessageSetup,ArgumentTransfer,SimpleCall,Jump,Label] , @ins
    end
  end
end
