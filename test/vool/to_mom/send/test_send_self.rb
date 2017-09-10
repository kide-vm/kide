require_relative "../helper"

module Vool
  class TestSendSelfMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "self.get_internal_word(0)").first
    end

    def test_class_compiles
      assert_equal Mom::SlotMove , @stats.first.class , @stats
    end
    def test_slot_is_set
      assert @stats.first.left
    end
    def test_two_instructions_are_returned
      assert_equal 3 ,  @stats.length
    end
    def test_receiver_move_class
      assert_equal Mom::SlotMove,  @stats.first.class
    end
    def test_receiver_move
      assert_equal :receiver,  @stats.first.left[2]
    end
    def test_receiver
      assert_equal SelfStatement,  @stats.first.right.class
      assert_equal :Test,  @stats.first.right.clazz.name
    end
    def test_arg_one
      assert_equal Mom::SlotConstant,  @stats[1].class
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
      Risc.machine.boot
      @stats = compile_first_method( "get_internal_word(0)").first
    end
  end
end
