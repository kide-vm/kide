require_relative "helper"

module Risc
  class TestPositionEvents < MiniTest::Test
    def setup
      Position.clear_positions
      @instruction = DummyInstruction.new
      @position = Position.new(@instruction , 0)
      @listener = PositionListener.new( @instruction )
    end
    def test_has_register
      assert @position.position_listener( @instruction )
    end
    def test_can_unregister
      listener = PositionListener.new(self)
      assert @position.position_listener(listener)
      assert @position.remove_position_listener(listener)
    end
    def test_fires
      @object = @instruction
      @position.register_event(:position_changed , self)#can't use helper
      @position.trigger_changed
      assert_equal @position , @trigger
    end
    def test_no_fire_after_unregister
      @object = @instruction
      Position.new(self, 10)
      assert @position.register_event(:position_changed , self)#can't use helper
      assert @position.remove_position_listener(self)
      @position.trigger(:position_changed , @position)
      assert_nil @trigger
    end
    def test_can_trigger_inserted
      @object = @instruction
      @position.register_event(:position_changed , self) #can't use helper
      @position.trigger_inserted
      assert_equal @position , @trigger
    end
    def test_position_set_triggers
      @object = @instruction
      Position.new(self, 0)
      @position.register_event(:position_changed , self)#can't use helper
      @position.set(10)
      assert_equal @position , @trigger
      assert_equal @to , 10
    end
    def position_changed(pos)
      @trigger = pos
    end
    def position_inserted(pos)
      @trigger = pos
    end
    def position_changing(pos , to)
      @trigger = pos
      @to = to
    end
  end
end
