require_relative "helper"

module Vool
  class TestIvarMom < MiniTest::Test
    include MomCompile

    def setup
      Risc.machine.boot
      @method = compile_first_method( "@a = 5")
    end

    def test_compiles_not_array
      assert Array != @stats.class , @stats
    end
    def test_class_compiles
      assert_equal Mom::SlotConstant , @method.first.class , @method
    end
    def test_slot_is_set
      assert @method.first.left
    end
    def test_slot_starts_at_message
      assert_equal :message , @method.first.left.known_object
    end
    def test_slot_gets_self
      assert_equal :receiver , @method.first.left.slots[0]
    end
    def test_slot_assigns_to_local
      assert_equal :a , @method.first.left.slots[-1]
    end
    def test_slot_assigns_something
      assert @method.first.right
    end
    def test_slot_assigns_int
      assert_equal Mom::IntegerConstant ,  @method.first.right.class
    end
  end
end
