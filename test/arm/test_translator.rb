require_relative 'helper'

module Arm
  class TestTranslator < MiniTest::Test

    def setup
      Parfait.boot!
      @jump = Risc::DynamicJump.new("" , :r1)
      @codes = Translator.new.translate @jump
    end
    def test_slot_class
      assert_equal MemoryInstruction , @codes.class
    end
    def test_slot_left
      assert_equal :r1 , @codes.left
    end
    def test_slot_result
      assert_equal :r1 , @codes.left
    end
    def test_slot_right
      assert_equal 4 , @codes.right
    end
    def test_next_from
      assert_equal :r1 , @codes.next.from.symbol
    end
    def test_next_class
      assert_equal MoveInstruction , @codes.next.class
    end
  end
end
