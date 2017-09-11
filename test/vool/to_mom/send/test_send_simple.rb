require_relative "../helper"
require_relative "simple_send_harness"

module Vool
  class TestSendSimpleMom < MiniTest::Test
    include MomCompile
    include SimpleSendHarness

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "5.mod4").first
      @first = @stats.first
    end
    def receiver
      [IntegerStatement , 5]
    end
    def test_call_has_right_method
      assert_equal :mod4,  @stats[2].method.name
    end

  end
end
