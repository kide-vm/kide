module Risc
  module Position

    # Instructions are also a linked list, but their position is not really
    # the position of the object.
    # Rather it is the position of the assembled code in the binary.
    # (Luckily arm is sane, so this is realtively simple)
    #
    # Really we only need to calculate Positions at a jump, so between the
    # Jump and the label it jumps too. The other instructions are "just" fill.
    # But off course we need to propagate positions to get it right.
    #
    # Assembled instructions are kept in BinaryCode objects.
    # When propagating positions we have to see that the next position assembles into
    # the same BinaryCode, or else move it and the code along
    #
    class InstructionPosition < ObjectPosition
      attr_reader :instruction , :binary
      def initialize(instruction, pos , binary)
        raise "not set " unless binary
        super(pos, instruction)
        @instruction = instruction
        @binary = binary
      end
      def init(at)
        diff = at - Position.get(@binary).at
        if( diff % 60 == 12*4)
          @binary.extend_one unless @binary.next
          @binary = @binary.next
          raise "end of line " unless @binary
          at = Position.get(@binary).at + 3*4
        end
        return unless instruction.next
        at += instruction.byte_length
        Position.set(instruction.next, at , binary)
      end

      def reset_to(pos)
        super(pos)
        #puts "Reset (#{changed}) #{instruction}"
        init(pos)
      end
    end
  end
end
