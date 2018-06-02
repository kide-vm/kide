require "util/eventable"

module Risc
  module Position
    class ObjectPosition
      include Util::Eventable

      attr_reader :at , :object

      # initialize with a given object, first parameter
      # The object ill be the key in global position map
      # Give an integer as the actual position, where -1
      # which means no legal position known
      def initialize(object , pos )
        @at = 0
        @object = object
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
      def init(pos , is_nil)
      end
      def reset_to(pos , guaranteed_nil )
        return false if pos == at
        if((at - pos).abs > 1000)
          raise "position set too far off #{pos}!=#{at} for #{object}:#{object.class}"
        end
        @at = pos
        trigger(:position_changed , self)
        true
      end
      def self.init(object , at = -1)
        position = ObjectPosition.new(object , at)
        Position.set_to( position , at)
      end
    end
  end
end
