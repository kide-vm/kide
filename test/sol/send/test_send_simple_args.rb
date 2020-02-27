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
      assert_equal SlottedConstant, @ins.next(1).arguments[1].class
    end
    def test_args_two_str
      assert_equal SlottedConstant,    @ins.next(1).arguments[1].class
      assert_equal 2,    @ins.next(1).arguments[1].known_object.value
    end
    def test_array
      check_array [MessageSetup,ArgumentTransfer,SimpleCall, SlotLoad, ReturnJump,
                  Label, ReturnSequence , Label] , @ins
    end
    def test_receiver_move
      assert_equal SlottedConstant,  @ins.next.receiver.class
    end

  end
end
