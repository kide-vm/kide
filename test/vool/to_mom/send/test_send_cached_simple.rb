require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method_flat( "a = 5; a.mod4")
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
      assert_equal @first.if_true[0].class, Mom::SlotLoad , @first.if_true.to_rxf
    end
    def test_if_true_resolves_setup
      assert_equal @first.if_true[1].class , Mom::MessageSetup,  @first.if_true.to_rxf
    end
    def test_if_true_resolves_transfer
      assert_equal @first.if_true[2].class , Mom::ArgumentTransfer,  @first.if_true.to_rxf
    end
    def test_if_true_resolves_call
      assert_equal @first.if_true[3].class , Mom::SimpleCall,  @first.if_true.to_rxf
    end
    def test_if_true_resolves_move
      assert_equal @first.if_true[4].class , Mom::SlotLoad,  @first.if_true.to_rxf
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

    def test_array
      check_array [SlotLoad,NotSameCheck,Label,SlotLoad,MessageSetup,ArgumentTransfer,SimpleCall,SlotLoad,Label,MessageSetup,ArgumentTransfer,DynamicCall] , @stats
    end

  end
end
