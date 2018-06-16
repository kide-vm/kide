require_relative "helper"

module Mom
  class TestSlotDefinitionBasics < MiniTest::Test

    def slot(slot = :caller)
      SlotDefinition.new(:message , slot)
    end
    def test_create_ok1
      assert_equal :message , slot.known_object
    end
    def test_create_ok2
      assert_equal Array , slot.slots.class
      assert_equal :caller , slot.slots.first
    end
    def test_to_s
      assert_equal "[message,caller]" , slot.to_s
    end
    def test_create_fail_none
      assert_raises {slot(nil)}
    end
  end
end
