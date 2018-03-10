require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "arg.mod4").first
      @first, @second , @third ,@fourth= @stats[0],@stats[1],@stats[2],@stats[3]
    end

    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_four_instructions_are_returned
      assert_equal 4 ,  @stats.length
    end
    def test_if_first
      assert_equal Mom::IfStatement , @first.class , @first
    end
    def test_if_condition_set
      assert_equal Mom::NotSameCheck , @first.condition.class , @first
    end
    def test_if_true_moves_type
      assert_equal @first.if_true[0].class, Mom::SlotMove , @first.to_rxf
    end
    def test_if_true_resolves
      assert_equal @first.if_true[1] , 2,  @first.if_true.to_rxf
    end




    def test_setup_second
      assert_equal Mom::MessageSetup ,  @second.class , @second.to_rxf
    end

    def test_transfer_third
      assert_equal Mom::ArgumentTransfer ,  @third.class , @third.to_rxf
    end

    def test_call_third
      assert_equal Mom::DynamicCall ,  @fourth.class , @fourth.to_rxf
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
