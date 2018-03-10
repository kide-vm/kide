require_relative "../helper"
require_relative "simple_send_harness"

module Vool
  class TestSendSimpleArgsMom < MiniTest::Test
    include MomCompile
    include SimpleSendHarness

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "5.mod4(1,2)").first
    end

    def receiver
      [IntegerStatement , 5]
    end
    def test_args_two_move
      assert_equal :next_message, @stats[1].arguments[1].left.slots[0]
      assert_equal :arguments,    @stats[1].arguments[1].left.slots[1]
    end
    def test_args_two_str
      assert_equal IntegerStatement,    @stats[1].arguments[1].right.class
      assert_equal 2,    @stats[1].arguments[1].right.value
    end
  end
end
