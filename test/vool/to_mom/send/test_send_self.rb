require_relative "../helper"
require_relative "simple_send_harness"

module Vool
  class TestSendSelfMom < MiniTest::Test
    include MomCompile
    include SimpleSendHarness
    include Mom

    def do_setup(str)
      Risc.machine.boot
      @ins = compile_first_method( str)
    end
    def setup
      do_setup("self.get_internal_word(0)")
    end
    def test_receiver
      assert_equal SlotDefinition,  @ins.next.receiver.class
    end
    def test_arg_one
      assert_equal SlotLoad,  @ins.next(1).arguments[0].class
    end
    def test_call_two
      assert_equal SimpleCall,  @ins.next(2).class
    end
    def test_call_has_method
      assert_equal Parfait::TypedMethod,  @ins.next(2).method.class
    end
    def test_call_has_right_method
      assert_equal :get_internal_word,  @ins.next(2).method.name
    end
  end
  class TestSendSelfImplicitMom < TestSendSelfMom

    def setup
      do_setup( "get_internal_word(0)")
    end
  end
end
