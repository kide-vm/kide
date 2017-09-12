require_relative "../helper"

module Vool
  class TestSendCachedSimpleMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "arg.mod4").first
      @first = @stats.first
    end

    def est_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def est_class_compiles
      assert_equal Mom::SlotConstant , @first.class , @stats
    end
    def est_slot_is_set
      assert @stats.first.left
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
