require_relative "helper"

module Sol
  class TestSendSimpleArgsSlotMachine < MiniTest::Test
    include SimpleSendHarness

    def send_method
      "5.div4(1,2);return"
    end

    def receiver
      [SlotMachine::IntegerConstant , 5]
    end
    def test_args_two_move
      assert_equal :next_message, @ins.next(1).arguments[1].left.slots[0]
      assert_equal :arg2,    @ins.next(1).arguments[1].left.slots[1]
    end
    def test_args_two_str
      assert_equal SlotMachine::IntegerConstant,    @ins.next(1).arguments[1].right.known_object.class
      assert_equal 2,    @ins.next(1).arguments[1].right.known_object.value
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall, SlotLoad, ReturnJump,
                  Label, ReturnSequence , Label] , @ins
    end
    def test_receiver_move
      assert_equal ConstantSlot,  @ins.next.receiver.class
    end

  end
end
