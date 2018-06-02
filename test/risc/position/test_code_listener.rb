require_relative "helper"

module Risc
  module Position
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
      def test_init_returns_position

        assert_equal Position::ObjectPosition , CodeListener.init(@binary).class
      end
      def test_init_listner
        @binary.extend_one
        CodeListener.init(@binary)
        pos = Position.get(@binary)
        assert !pos.event_table[:position_changed].empty?
      end
      def test_not_init_listner
        CodeListener.init(@binary)
        pos = Position.get(@binary)
        assert pos.event_table[:position_changed].empty?
      end
    end
  end
end
