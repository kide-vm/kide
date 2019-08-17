require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include VoolCompile

    def setup
      @compiler = compile_first_method( "a = 5; a.div4;return ")
      @ins = @compiler.mom_instructions.next
    end
    def test_check_type
      assert_equal NotSameCheck , @ins.next(1).class , @ins
    end
    def test_type_update
      load =  @ins.next(2)
      assert_equal :message , load.right.known_object , load
      assert_equal :frame , load.right.slots[0] , load
      assert_equal :a , load.right.slots[1] , load
      assert_equal :type , load.right.slots[2] , load
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
