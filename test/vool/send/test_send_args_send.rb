require_relative "helper"

module Vool
  class TestSendArgsSendMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      Risc.boot!
      @compiler = compile_first_method( "a = main(1 + 2)" )
      @ins = @compiler.mom_instructions.next
    end

    def test_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, MessageSetup ,
                    ArgumentTransfer, SimpleCall, SlotLoad ,Label, ReturnSequence ,
                    Label] , @ins
    end

    def test_one_call
      assert_equal SimpleCall, @ins.next(2).class
      assert_equal :+, @ins.next(2).method.name
    end
    def test_two_call
      assert_equal SimpleCall, @ins.next(6).class
      assert_equal :main, @ins.next(6).method.name
    end
    def test_args_one_l
      left = @ins.next(1).arguments[0].left
      assert_equal Symbol, left.known_object.class
      assert_equal :message, left.known_object
      assert_equal [:next_message, :arguments, 1], left.slots
    end
  end
end
