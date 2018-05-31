module Risc
  module Position
    class ObjectPosition
      attr_reader :at , :object

      def initialize( object, at)
        @at = at
        @object = object
        @listeners = []
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
      def init(pos , is_nil)
      end
      def reset_to(pos , guaranteed_nil )
        return false if pos == at
        if((at - pos).abs > 1000)
          raise "position set too far off #{pos}!=#{at} for #{object}:#{object.class}"
        end
        @at = pos
        true
      end

      # Register a handler position change event.
      # The object calls position_changed on the handler object
      #
      #   obj.position_changed( changed_position )
      #
      # @param [Object] object handling position_changed
      def register_listener( handler)
        @listeners << handler
      end

      def unregister_listener(handler)
        @listeners.delete handler
      end

      # Trigger position change  and pass self to position_changed
      def trigger()
        @listeners.each { |handler| handler.position_changed( self ) }
      end
    end
  end
end
