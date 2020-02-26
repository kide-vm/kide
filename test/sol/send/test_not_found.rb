require_relative "../helper"

module Sol
  class TestNotFoundSlotMachine < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "5.div8")
      @ins = @compiler.slot_instructions.next
    end
    def test_check_type
      assert_equal NotSameCheck , @ins.class , @ins
    end
    def test_check_resolve_call
      assert_equal ResolveMethod , @ins.next(2).class , @ins
    end
    def test_dynamic_call_last
      assert_equal DynamicCall ,  @ins.next(6).class , @ins
    end

    def test_array
      check_array [NotSameCheck, SlotLoad, ResolveMethod, Label, MessageSetup ,
                    ArgumentTransfer, DynamicCall, SlotLoad, ReturnJump,
                    Label, ReturnSequence, Label]  , @ins
    end

  end
end
