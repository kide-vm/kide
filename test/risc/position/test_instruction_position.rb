require_relative "../helper"

module Risc
  module Position
    # tests that require a boot and test propagation
    class TestPositionBasic < MiniTest::Test
      def setup
        Risc.machine.boot
        @binary = Parfait::BinaryCode.new(1)
        Position.set(@binary , 0)
        @label = Label.new("hi","ho")
      end
      def test_set_instr
        pos = Position.set( @label , 0 , @binary)
        assert_equal InstructionPosition , pos.class
      end
      def test_ins_propagates
        @label.set_next Arm::ArmMachine.b( @label)
        Position.set( @label , 0 , @binary)
        assert_equal 0 , Position.get(@label.next).at
      end
      def test_ins_propagates_again
        second = Arm::ArmMachine.b( @label)
        @label.set_next(second)
        Position.set( @label , 0 , @binary)
        Position.set(second , 2 , @binary)
        Position.set( @label , 0 , @binary)
        assert_equal 0 , Position.get(@label.next).at
      end
    end
  end
end
