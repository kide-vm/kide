require_relative "../helper"

module Vool
  class TestSendSelfMom < MiniTest::Test
    include MomCompile

    def do_setup(str)
      Risc.machine.boot
      @stats = compile_first_method( str).first
      @first = @stats.first
    end
    def setup
      do_setup("self.get_internal_word(0)")
    end

    def test_compiles
      assert_equal Mom::Statements , @stats.class , @stats
    end
    def test_compile_starts_with_setup
      assert_equal Mom::MessageSetup , @stats[0].class , @stats
    end
    def test_compile_continues_with_transfer
      assert_equal Mom::ArgumentTransfer , @stats[1].class , @stats
    end
    def test_method_is_set
      assert @first.method
    end
    def test_three_instructions_are_returned
      assert_equal 3 ,  @stats.length
    end
    def test_arg_transfers
      assert_equal Mom::ArgumentTransfer,  @stats[1].class
    end
    def test_receiver_move
      assert_equal Mom::SlotMove,  @stats[1].receiver.class
    end
    def test_receiver_self
      assert_equal SelfStatement,  @stats[1].receiver.right.class
    end
    def test_arg_one
      assert_equal Mom::SlotConstant,  @stats[1].arguments[0].class
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
