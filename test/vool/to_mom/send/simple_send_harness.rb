module Vool
  # relies on @stats and receiver_type method
  module SimpleSendHarness
    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_class_compiles
      assert_equal Mom::MessageSetup , @stats.class , @stats
    end
    def test_two_instructions_are_returned
      assert_equal 3 ,  @stats.length , @stats.to_rxf
    end
    def test_receiver_move_class
      assert_equal Mom::ArgumentTransfer,  @stats[1].class
    end
    def test_receiver_move
      assert_equal :receiver,  @stats[1].receiver.left.slots[1]
    end
    def test_receiver
      type , value = receiver
      assert_equal type,  @stats[1].receiver.right.class
      assert_equal value,  @stats[1].receiver.right.value
    end
    def test_call_is
        assert_equal Mom::SimpleCall,  @stats[2].class
    end
    def test_call_has_method
      assert_equal Parfait::TypedMethod,  @stats[2].method.class
    end
  end
end
