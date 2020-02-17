require_relative "helper"

module SlotMachine
  class TestSlot < MiniTest::Test

    def slot(slot = :caller , nekst = nil)
      sl = Slot.new(slot)
      sl.set_next( Slot.new(nekst)) if nekst
      sl
    end
    def test_name
      assert_equal :caller , slot.name
    end
    def test_length
      assert_equal 1 , slot.length
    end
    def test_length2
      assert_equal 2 , slot(:caller , :next).length
    end
    def test_to_s
      assert_equal "caller" , slot.to_s
    end
    def test_to_s2
      assert_equal "caller.next" , slot(:caller , :next).to_s
    end
    def test_create_fail_none
      assert_raises {slot(nil)}
    end
  end
end
