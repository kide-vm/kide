require_relative "helper"

module Risc
  # tests that require a boot and test propagation
  class TestCodeListenerFull < MiniTest::Test
    def setup
      #@machine = DummyPlatform.boot
      @machine = Risc.machine.boot
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Risc.label("hi","ho")
      #@machine.set_translated
      @machine.translate(:interpreter)
      @machine.position_all
    end
    def test_listener_after_extend
      CodeListener.init(@binary).set(0)
      @binary.extend_one
      pos = Position.get(@binary.next)
      assert_equal CodeListener , pos.event_table[:position_changed].first.class
    end
    def test_extend_sets_next_pos
      CodeListener.init(@binary).set(0)
      @binary.extend_one
      assert Position.get(@binary.next)
    end
  end
end
