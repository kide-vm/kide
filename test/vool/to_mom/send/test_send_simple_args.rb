require_relative "helper"

module Vool
  class TestSendSimpleArgsMom < MiniTest::Test
    include SimpleSendHarness

    def send_method
      "5.div4(1,2)"
    end

    def receiver
      [Mom::IntegerConstant , 5]
    end
    def test_args_two_move
      assert_equal :next_message, @ins.next(1).arguments[1].left.slots[0]
      assert_equal :arguments,    @ins.next(1).arguments[1].left.slots[1]
    end
    def test_args_two_str
      assert_equal Mom::IntegerConstant,    @ins.next(1).arguments[1].right.known_object.class
      assert_equal 2,    @ins.next(1).arguments[1].right.known_object.value
    end
    def test_array
      check_array [Mom::MessageSetup,Mom::ArgumentTransfer,Mom::SimpleCall] , @ins
    end
  end
end
