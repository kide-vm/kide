require_relative "helper"

module Risc
  # tests that require a boot and test propagation
  class TestcodeListener < MiniTest::Test
    def setup
      Risc.machine.boot
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Risc.label("hi","ho")
    end

    def test_has_init
      pos = CodeListener.init(@binary)
      assert_equal pos, Position.get(@binary)
    end
    def test_init_fail
      assert_raises{ CodeListener.init( @method)}
    end
    def test_init_returns_position
      assert_equal Position , CodeListener.init(@binary).class
    end
    def test_not_init_listner
      pos = CodeListener.init(@binary)
      assert CodeListener == pos.event_table[:position_changed].last.class
    end
    def test_init_listner
      @binary.extend_one
      CodeListener.init(@binary)
      pos = Position.get(@binary)
      assert_equal CodeListener , pos.event_table[:position_changed].first.class
    end
    def test_extends_creates_jump
      @binary.extend_one
      CodeListener.init(@binary)
    end
  end
end
