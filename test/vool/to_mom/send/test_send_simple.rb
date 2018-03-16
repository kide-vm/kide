require_relative "../helper"
require_relative "simple_send_harness"

module Vool
  class TestSendSimpleMom < MiniTest::Test
    include MomCompile
    include SimpleSendHarness

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "5.mod4")
    end
    def receiver
      [Mom::IntegerConstant , 5]
    end
    def test_call_has_right_method
      assert_equal :mod4,  @ins.next(3).method.name
    end

  end
end
