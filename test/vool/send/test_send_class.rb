require_relative "helper"

module Vool
  class TestSendClassMom < MiniTest::Test
    include SimpleSendHarness
    include Mom

    def send_method
      "Object.get_internal_word(0)"
    end
    def test_receiver
      assert_equal SlotDefinition,  @ins.next.receiver.class
    end
    def test_arg_one
      assert_equal SlotLoad,  @ins.next(1).arguments[0].class
    end
    def test_call_two
      assert_equal SimpleCall,  @ins.next(2).class
    end
    def test_call_has_method
      assert_equal Parfait::CallableMethod,  @ins.next(2).method.class
    end
    def test_call_has_right_method
      assert_equal :get_internal_word,  @ins.next(2).method.name
    end
    def test_call_has_right_receiver
      assert_equal "Object_Type",  @ins.next(2).method.self_type.name
    end
  end
end
