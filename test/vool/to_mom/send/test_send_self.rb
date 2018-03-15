require_relative "../helper"
require_relative "simple_send_harness"

module Vool
  class TestSendSelfMom < MiniTest::Test
    include MomCompile
    include SimpleSendHarness

    def do_setup(str)
      Risc.machine.boot
      @stats = compile_first_method( str).first
      @first = @stats.first
    end
    def setup
      do_setup("self.get_internal_word(0)")
    end

    def test_receiver
      assert_equal Mom::SlotDefinition,  @stats[1].receiver.right.class
    end

    def test_arg_one
      assert_equal Mom::SlotLoad,  @stats[1].arguments[0].class
    end
    def test_call_two
      assert_equal Mom::SimpleCall,  @stats[2].class
    end
    def test_call_has_method
      assert_equal Parfait::TypedMethod,  @stats[2].method.class
    end
    def test_call_has_right_method
      assert_equal :get_internal_word,  @stats[2].method.name
    end
  end
  class TestSendSelfImplicitMom < TestSendSelfMom

    def setup
      do_setup( "get_internal_word(0)")
    end
  end
end
