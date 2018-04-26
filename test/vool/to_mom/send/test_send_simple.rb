require_relative "helper"

module Vool
  class TestSendSimpleMom < MiniTest::Test
    include SimpleSendHarness

    def send_method
      "5.div4"
    end
    def receiver
      [Mom::IntegerConstant , 5]
    end
    def test_call_has_right_method
      assert_equal :div4,  @ins.next(2).method.name
    end

  end
end
