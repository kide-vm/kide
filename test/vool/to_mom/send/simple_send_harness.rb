module Vool
  # relies on @ins and receiver_type method
  module SimpleSendHarness
    def test_compiles_not_array
      assert Array != @ins.class , @ins
    end
    def test_class_compiles
      assert_equal Mom::MessageSetup , @ins.class , @ins
    end
    def test_two_instructions_are_returned
      assert_equal 3 ,  @ins.length , @ins
    end
    def test_receiver_move_class
      assert_equal Mom::ArgumentTransfer,  @ins.next(1).class
    end
    def test_receiver_move
      assert_equal Mom::SlotDefinition,  @ins.next.receiver.class
    end
    def test_receiver
      type , value = receiver
      assert_equal type,  @ins.next.receiver.known_object.class
      assert_equal value,  @ins.next.receiver.known_object.value
    end
    def test_call_is
        assert_equal Mom::SimpleCall,  @ins.next(2).class
    end
    def test_call_has_method
      assert_equal Parfait::TypedMethod,  @ins.next(2).method.class
    end
    def test_array
      check_array [Mom::MessageSetup,Mom::ArgumentTransfer,Mom::SimpleCall] , @ins
    end
  end
end
