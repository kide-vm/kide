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
      assert_equal IfStatement , @ins.class , @ins
    end
    def test_if_condition_set
      assert_equal NotSameCheck , @ins.condition.class , @ins
    end
    def test_if_true_moves_type
      assert_equal @ins.if_true[0].class, SlotLoad , @ins.if_true.to_rxf
    end
    def test_if_true_resolves_setup
      assert_equal @ins.if_true[1].class , MessageSetup,  @ins.if_true.to_rxf
    end
    def test_if_true_resolves_transfer
      assert_equal @ins.if_true[2].class , ArgumentTransfer,  @ins.if_true.to_rxf
    end
    def test_if_true_resolves_call
      assert_equal @ins.if_true[3].class , SimpleCall,  @ins.if_true.to_rxf
    end
    def test_if_true_resolves_move
      assert_equal @ins.if_true[4].class , SlotLoad,  @ins.if_true.to_rxf
    end

    def test_setup_second
      assert_equal MessageSetup ,  @ins.next.class , @second.to_rxf
    end

    def test_transfer_third
      assert_equal ArgumentTransfer ,  @ins.next(2).class , @third.to_rxf
    end

    def test_call_third
      assert_equal DynamicCall ,  @ins.last.class , @fourth.to_rxf
    end

    def test_array
      check_array [SlotLoad,NotSameCheck,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,SimpleCall,SlotLoad,MessageSetup,SlotLoad,ArgumentTransfer,DynamicCall] , @ins
    end

  end
end
