require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile
    include Mom

    def setup
      Risc.machine.boot
      @ins = compile_first_method_flat( "a = 5; a.mod4")
    end
    def test_if_first
      assert_equal Mom::IfStatement , @ins.class , @ins
    end
    def test_if_condition_set
      assert_equal Mom::NotSameCheck , @ins.condition.class , @ins
    end
    def test_if_true_moves_type
      assert_equal @ins.if_true[0].class, Mom::SlotLoad , @ins.if_true.to_rxf
    end
    def test_if_true_resolves_setup
      assert_equal @ins.if_true[1].class , Mom::MessageSetup,  @ins.if_true.to_rxf
    end
    def test_if_true_resolves_transfer
      assert_equal @ins.if_true[2].class , Mom::ArgumentTransfer,  @ins.if_true.to_rxf
    end
    def test_if_true_resolves_call
      assert_equal @ins.if_true[3].class , Mom::SimpleCall,  @ins.if_true.to_rxf
    end
    def test_if_true_resolves_move
      assert_equal @ins.if_true[4].class , Mom::SlotLoad,  @ins.if_true.to_rxf
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
      check_array [SlotLoad,NotSameCheck,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,DynamicCall] , @ins
    end

  end
end
