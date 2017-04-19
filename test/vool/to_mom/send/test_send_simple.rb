require_relative "../helper"

module Vool
  class TestSendMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "5.mod4").first
    end

    def test_class_compiles
      assert_equal Mom::SlotConstant , @stats.first.class , @stats
    end
    def test_slot_is_set
      assert @stats.first.left
    end
    def test_two_instructions_are_returned
      assert_equal 2 ,  @stats.length
    end
    def test_receiver_move_class
      assert_equal Mom::SlotConstant,  @stats.first.class
    end
    def test_receiver_move
      assert_equal :receiver,  @stats.first.left[2]
    end
    def test_receiver
      assert_equal IntegerStatement,  @stats.first.right.class
      assert_equal 5,  @stats.first.right.value
    end
    def test_call_is
      assert_equal Mom::SimpleCall,  @stats[1].class
    end
    def test_call_has_method
      assert_equal Parfait::TypedMethod,  @stats[1].method.class
    end
    def test_call_has_right_method
      assert_equal :mod4,  @stats[1].method.name
    end
  end
end
