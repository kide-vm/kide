require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "arg.mod4").first
      @first = @stats.first
    end

    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_if_first
      assert_equal Mom::IfStatement , @first.class , @first
    end
    def test_if_condition_set
      assert_equal Mom::NotSameCheck , @first.condition.class , @first
    end
    def test_if_true_set
      assert @first.if_true , @first
    end
    def test_if_true_not_empty
      assert @first.if_true.first , @first
    end
    def test_slot_is_set
      assert_equal 1 ,  @stats , @stats.to_rxf
    end
    def est_two_instructions_are_returned
      assert_equal 2 ,  @stats.length
    end
    def est_receiver_move_class
      assert_equal Mom::SlotConstant,  @first.class
    end
    def est_receiver_move
      assert_equal :receiver,  @first.left[2]
    end
    def est_receiver
      assert_equal IntegerStatement,  @first.right.class
      assert_equal 5,  @stats.first.right.value
    end
    def est_call_is
      assert_equal Mom::SimpleCall,  @stats[1].class
    end
    def est_call_has_method
      assert_equal Parfait::TypedMethod,  @stats[1].method.class
    end
    def est_call_has_right_method
      assert_equal :mod4,  @stats[1].method.name
    end
  end
end
