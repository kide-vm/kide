require_relative "../helper"

module Vool
  class TestSendSimpleStringArgsMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "'5'.get_internal_byte(1)").first
    end

    def test_class_compiles
      assert_equal Mom::SlotConstant , @stats.first.class , @stats
    end
    def test_four_instructions_are_returned
      assert_equal 3 ,  @stats.length
    end
    def test_receiver_move
      assert_equal Mom::SlotConstant,  @stats.first.class
      assert_equal :receiver,  @stats[0].left[2]
    end
    def test_receiver
      assert_equal StringStatement,  @stats[0].right.class
      assert_equal "5",  @stats[0].right.value
    end
    def test_args_one_move
      assert_equal :next_message, @stats[1].left[1]
      assert_equal :arguments,    @stats[1].left[2]
    end
    def test_args_one_int
      assert_equal IntegerStatement,    @stats[1].right.class
      assert_equal 1,    @stats[1].right.value
    end
    def test_call_is
      assert_equal Mom::SimpleCall,  @stats[2].class
    end
    def test_call_has_method
      assert_equal Parfait::TypedMethod ,  @stats[2].method.class
    end
    def test_call_has_right_method
      assert_equal :get_internal_byte,  @stats[2].method.name
    end
  end
end
