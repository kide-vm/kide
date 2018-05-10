require_relative "../helper"

module Risc
  # tests that require a boot and test propagation
  class TestPositionBasic < MiniTest::Test
    def setup
      Risc.machine.boot
      @binary = Parfait::BinaryCode.new(1)
      @label = Label.new("hi","ho")
    end
    def test_set_bin
      pos = Position.set( @binary , 0 , Parfait.object_space.get_main)
      assert_equal Position::CodePosition , pos.class
    end
    def test_bin_propagates_existing
      @binary.extend_to(16)
      Position.set( @binary , 0 , Parfait.object_space.get_main)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
    def test_bin_propagates_after
      Position.set( @binary , 0 , Parfait.object_space.get_main)
      @binary.extend_to(16)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
  end
end
