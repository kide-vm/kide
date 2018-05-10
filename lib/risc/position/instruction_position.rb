module Risc
  module Position

    class InstructionPosition < ObjectPosition
      attr_reader :instruction , :binary
      def initialize(instruction, pos , binary)
        raise "not set " unless binary
        super(pos)
        @instruction = instruction
        @binary = binary
      end

      def init(at)
        return unless instruction.next
        at += instruction.byte_length
        bin = binary
        if( 12 == at % 60)
          at = 12
          bin = binary.next
        end
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
