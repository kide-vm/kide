require_relative "helper"

module Sol
  class TestSendSelfSlotMachine < MiniTest::Test
    include SimpleSendHarness

    def send_method
      "self.get_internal_word(0);return"
    end
    def test_receiver
      assert_equal SlottedMessage,  @ins.next.receiver.class
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
    def test_receiver_move
      assert_equal SlottedMessage,  @ins.next.receiver.class
    end

  end
  class TestSendSelfImplicitSlotMachine < TestSendSelfSlotMachine

    def send_method
      "get_internal_word(0)"
    end
  end
end
