require_relative "../helper"

module Sol
  class TestSendCachedSimpleSlotMachine < MiniTest::Test
    include SolCompile

    def setup
      @compiler = compile_main( "a = 5; a.div4;return ")
      @ins = @compiler.slot_instructions.next
    end
    def test_check_type
      assert_equal NotSameCheck , @ins.next(1).class , @ins
    end
    def test_type_update
      load =  @ins.next(2)
      assert_equal :message , load.right.known_object , load
      assert_equal :local1 , load.right.slots.name , load
      assert_equal :type , load.right.slots.next_slot.name , load
    end
    def test_check_resolve_call
      assert_equal ResolveMethod , @ins.next(3).class , @ins
    end
    def test_dynamic_call_last
      assert_equal DynamicCall ,  @ins.next(7).class , @ins
    end

    def test_array
      check_array [SlotLoad, NotSameCheck, SlotLoad, ResolveMethod ,
                    Label, MessageSetup, ArgumentTransfer, DynamicCall,
                    SlotLoad, ReturnJump, Label ,
                    ReturnSequence, Label]  , @ins
    end

  end
end
