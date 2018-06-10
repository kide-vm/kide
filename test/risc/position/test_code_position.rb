require_relative "helper"

module Risc
  class TestPositionTranslated < MiniTest::Test
    def setup
      machine = Risc.machine.boot
      machine.translate(:interpreter)
      @binary = Parfait::BinaryCode.new(1)
      @method = Parfait.object_space.types.values.first.methods
      @label = Risc.label("hi","ho")
    end

    def test_bin_propagates_existing
      @binary.extend_to(16)
      CodeListener.init( @binary).set(0)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
    def test_bin_propagates_after
      CodeListener.init( @binary).set(0)
      @binary.extend_to(16)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
  end
end
