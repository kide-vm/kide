require_relative "helper"

module Vool
  class TestYieldArgsSendMom #< MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Parfait.boot!
      @ins = compile_first_method( "yield(1)" )
    end

    def test_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, MessageSetup ,
                    ArgumentTransfer, SimpleCall, SlotLoad] , @ins
    end

    def pest_one_call
      assert_equal SimpleCall, @ins.next(2).class
      assert_equal :+, @ins.next(2).method.name
    end
    def pest_two_call
      assert_equal SimpleCall, @ins.next(6).class
      assert_equal :main, @ins.next(6).method.name
    end
    def pest_args_one_l
      left = @ins.next(1).arguments[0].left
      assert_equal Symbol, left.known_object.class
      assert_equal :message, left.known_object
      assert_equal [:next_message, :arguments, 1], left.slots
    end
  end
end
