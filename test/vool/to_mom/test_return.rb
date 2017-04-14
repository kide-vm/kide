require_relative "helper"

module Vool
  class TestReturnMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "return 5").first
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
    def test_second_is_return
      assert_equal Mom::ReturnSequence,  @stats.last.class
    end
    def test_slot_starts_at_message
      assert_equal :message , @stats.first.left[0]
    end
    def test_slot_gets_return
      assert_equal :return_value , @stats.first.left[1]
    end
    def test_slot_assigns_something
      assert @stats.first.right
    end
    def test_slot_assigns_int
      assert_equal IntegerStatement ,  @stats.first.right.class
    end
  end
end
