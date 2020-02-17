require_relative "helper"

module SlotMachine
  class TestSlottedMessage < MiniTest::Test

    def slotted(slot = [:caller])
      SlottedMessage.new(slot)
    end
    def test_create_ok1
      assert_equal :message , slotted.known_object
    end
    def test_create_ok2
      assert_equal Slot , slotted.slots.class
      assert_equal :caller , slotted.slots.name
    end
    def test_create_fail_none
      assert_raises {slotted(nil)}
    end
  end
end
