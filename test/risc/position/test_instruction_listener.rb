require_relative "helper"

module Risc
  module Position
    # tests that require a boot and test propagation
    class TestInstructionListener < MiniTest::Test
      def setup
        Risc.machine.boot
        @binary = Parfait::BinaryCode.new(1)
        #Position.set(@binary , 0 , Parfait.object_space.get_main)
        @label = Risc.label("hi","ho")
      end
      def test_init
        assert InstructionListener.init(@label , @binary)
      end
      def pest_set_instr
        pos = Position.set( @label , 8 , @binary)
        assert_equal InstructionPosition , pos.class
      end
      def pest_label_set_int
        Position.set( @label , 8 , @binary)
        assert_equal 8 , @label.address.value
      end
      def pest_label_reset_int
        Position.set( @label , 8 , @binary)
        Position.set( @label , 18 , @binary)
        assert_equal 18 , @label.address.value
      end
      def pest_ins_propagates
        @label.set_next Arm::ArmMachine.b( @label)
        Position.set( @label , 8 , @binary)
        assert_equal 8 , Position.get(@label.next).at
      end
      def pest_ins_propagates_again
        second = Arm::ArmMachine.b( @label)
        @label.set_next(second)
        Position.set( @label , 8 , @binary)
        Position.set(second , 12 , @binary)
        Position.set( @label , 8 , @binary)
        assert_equal 8 , Position.get(@label.next).at
      end
      def pest_label_at
        branch = Branch.new("b" , @label)
        Position.set(@label , 8 , @binary)
        Position.set(branch , 8 , @binary)
        at_4 = Position.at(8)
        assert_equal InstructionPosition , at_4.class
        assert_equal Branch , at_4.instruction.class
      end
      def pest_label_at_reverse
        branch = Branch.new("b" , @label)
        Position.set(branch , 8 , @binary)
        Position.set(@label , 8 , @binary)
        at_4 = Position.at(8)
        assert_equal InstructionPosition , at_4.class
        assert_equal Branch , at_4.instruction.class
      end
      def pest_reset_false_type
        assert_raises {Position.set(@label , 0 , @binary)}
      end
    end
  end
end
