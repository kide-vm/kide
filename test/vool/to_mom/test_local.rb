require_relative "helper"

module Vool
  class TestLocalMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @stats = compile_first_method( "a = 5")
      @first = @stats.first
    end

    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_class_compiles
      assert_equal Mom::SlotLoad , @first.class , @stats
    end
    def test_slot_is_set
      assert @first.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @first.left.known_object
    end
    def test_slot_gets_frame
      assert_equal :frame , @first.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :a , @first.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @first.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @first.right.class
    end
  end
end
