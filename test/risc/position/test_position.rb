require_relative "helper"

module Risc
  # tests that do no require a boot and only test basic positioning
  class TestPosition < MiniTest::Test

    def setup
      @pos = Position.new(self )
    end
    def test_new
      assert @pos
    end
    def test_invalid
      assert !@pos.valid?
    end
    def test_next_slot
      mov = Arm::ArmMachine.mov(:r1 , :r1)
      position = Position.new(mov ).set(0)
      assert_equal 4, position.next_slot
    end
    def test_has_get_code
      assert_nil @pos.get_code
    end
    def test_has_listeners_helper
      assert_equal Array , @pos.position_listeners.class
    end
    def test_has_trigger_inserted
      assert_equal [] , @pos.trigger_inserted
    end
    def test_has_trigger_changed
      assert_equal [] , @pos.trigger_changed
    end
    def test_listeners_empty
      assert @pos.position_listeners.empty?
    end
    def test_has_listener_helper
      @pos.position_listener( self )
      assert_equal 1 , @pos.position_listeners.length
    end
    def test_set
      assert_equal 0 , @pos.set(0).at
    end
  end
end
