require_relative "helper"

module Vool
  class TestLocalMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "a = 5")
    end

    def test_class_compiles
      assert_equal Mom::SlotConstant , @stats.first.class , @stats
    end
    def test_slot_is_set
      assert @stats.first.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @stats.first.left[0]
    end
    def test_slot_gets_self
      assert_equal :frame , @stats.first.left[1]
    end
    def test_slot_assigns_to_local
      assert_equal :a , @stats.first.left[-1]
    end
    def test_slot_assigns_something
      assert @stats.first.right
    end
    def test_slot_assigns_int
      assert_equal IntegerStatement ,  @stats.first.right.class
    end
  end
end
