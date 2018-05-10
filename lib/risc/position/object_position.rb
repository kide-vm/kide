module Risc
  module Position
    class ObjectPosition
      attr_reader :at

      def initialize( at )
        @at = at
        raise "not int #{self}-#{at}" unless @at.is_a?(Integer)
      end

      def +(offset)
        offset = offset.at if offset.is_a?(ObjectPosition)
        @at + offset
      end

      def -(offset)
        offset = offset.at if offset.is_a?(ObjectPosition)
        @at - offset
      end
      def to_s
        "0x#{@at.to_s(16)}"
      end
      # just a callback after creation AND insertion
      def init(pos)
      end
      def reset_to(pos)
        return false if pos == at
        if((at - pos).abs > 1000)
          raise "position set too far off #{pos}!=#{at} for #{object}:#{object.class}"
        end
        @at = pos
        true
      end
    end
  end
end
