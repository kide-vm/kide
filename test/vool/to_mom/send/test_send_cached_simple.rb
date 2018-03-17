require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method_flat( "a = 5; a.mod4")
    end
    def test_check_type
      assert_equal NotSameCheck , @ins.next.class , @ins
    end
    def test_type_update
      load =  @ins.next(2)
      assert_equal :message , load.right.known_object , load
      assert_equal :receiver , load.right.slots[0] , load
      assert_equal :type , load.right.slots[1] , load
    end
    def test_check_resolve_call
      assert_equal SimpleCall , @ins.next(6).class , @ins
    end
    def test_dynamic_call_last
      assert_equal DynamicCall ,  @ins.last.class , @ins
    end

    def test_array
      check_array [SlotLoad,NotSameCheck,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,DynamicCall] , @ins
    end

  end
end
