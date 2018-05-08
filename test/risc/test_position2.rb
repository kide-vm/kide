require_relative "../helper"

module Risc
  # tests that require a boot and test propagation
  class TestPositionBasic < MiniTest::Test
    def setup
      Risc.machine.boot
      @binary = Parfait::BinaryCode.new(1)
      @label = Label.new("hi","ho")
    end
    def test_set_instr
      pos = Position.set( @label , 0 , @binary)
      assert_equal IPosition , pos.class
    end
    def test_set_bin
      pos = Position.set( @binary , 0 , Parfait.object_space.get_main)
      assert_equal BPosition , pos.class
    end
    def test_ins_propagates
      @label.set_next Arm::ArmMachine.b( @label)
      Position.set( @label , 0 , @binary)
      assert_equal 0 , Position.get(@label.next).at
    end
    def test_bin_propagates
      @binary.extend_to(16)
      Position.set( @binary , 0 , Parfait.object_space.get_main)
      assert_equal @binary.padded_length , Position.get(@binary.next).at
    end
  end
end
