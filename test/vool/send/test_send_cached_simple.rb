require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Parfait.boot!
      @ins = compile_first_method( "a = 5; a.div4")
    end
    def test_check_type
      assert_equal NotSameCheck , @ins.next.class , @ins
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
      assert_equal DynamicCall ,  @ins.last.class , @ins
    end

    def test_array
      check_array [SlotLoad, NotSameCheck, SlotLoad, ResolveMethod, Label, MessageSetup ,
                    ArgumentTransfer, DynamicCall] , @ins
    end

  end
end
