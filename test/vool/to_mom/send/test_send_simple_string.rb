require_relative "../helper"
require_relative "simple_send_harness"

module Vool
  class TestSendSimpleStringArgsMom < MiniTest::Test
    include MomCompile
    include SimpleSendHarness

    def setup
      Risc.machine.boot
      @ins = compile_first_method( "'5'.get_internal_byte(1)")
    end
    def receiver
      [Mom::StringConstant , "5"]
    end

    def test_args_one_move
      assert_equal :next_message, @ins.next.next.arguments[0].left.slots[0]
      assert_equal :arguments,    @ins.next.next.arguments[0].left.slots[1]
    end
    def test_args_one_str
      assert_equal Mom::IntegerConstant,    @ins.next.next.arguments[0].right.class
      assert_equal 1,    @ins.next.next.arguments[0].right.value
    end
    def test_array
      check_array [Mom::MessageSetup,Mom::SlotLoad,Mom::ArgumentTransfer,Mom::SimpleCall] , @ins
    end
  end
end
