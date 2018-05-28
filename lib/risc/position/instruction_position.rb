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
        raise "not set #{binary}" if pos != 0 and !binary.is_a?(Parfait::BinaryCode)
        super(instruction,pos)
        @instruction = instruction
        @binary = binary
      end
      def init(at, binary)
        return if at == 0 and binary.nil?
        raise "faux pas" if at < Position.get(binary).at
        return unless @instruction.next
        @binary = binary
        nekst = at + @instruction.byte_length
        diff = nekst - Position.get(@binary).at
        Position.log.debug "Diff: #{diff.to_s(16)} , next #{nekst.to_s(16)} , binary #{Position.get(@binary)}"
        raise "Invalid position #{diff.to_s(16)} , next #{nekst.to_s(16)} #{self}" if diff < 8
        next_binary = @binary
        if( (diff % (@binary.padded_length - @instruction.byte_length)) == 0 )
          next_binary.extend_one unless next_binary.next
          next_binary = next_binary.next
          raise "end of line " unless next_binary
          nekst = Position.get(next_binary).at + Parfait::BinaryCode.byte_offset
          Position.log.debug "Jump to: #{nekst.to_s(16)}"
        end
        Position.set(@instruction.next, nekst , next_binary)
      end

      def reset_to(pos , binary)
        init(pos , binary)
        super(pos , binary)
        Position.log.debug "ResetInstruction (#{pos.to_s(16)}) #{instruction}"
      end
    end
  end
end
