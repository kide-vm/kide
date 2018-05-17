require_relative "../helper"

module Risc
  module Position
    # tests that require a boot and test propagation
    class TestPositionBasic < MiniTest::Test
      def setup
        Risc.machine.boot
        @binary = Parfait::BinaryCode.new(1)
        Position.set(@binary , 0,Parfait.object_space.get_main)
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
      def test_label_at
        branch = Branch.new("b" , @label)
        Position.set(@label , 4 , @binary)
        Position.set(branch , 4 , @binary)
        at_4 = Position.at(4)
        assert_equal InstructionPosition , at_4.class
        assert_equal Branch , at_4.instruction.class
      end
    end
  end
end
