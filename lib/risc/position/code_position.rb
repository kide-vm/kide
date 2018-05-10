module Risc
  module Position

    class CodePosition < ObjectPosition
      attr_reader :code , :method
      def initialize(code, pos , method)
        super(pos)
        @code = code
        @method = method
      end
      def init(at)
        return unless code.next
        Position.set(code.next , at + code.padded_length, method)
      end
      def reset_to(pos)
        super(pos)
        #puts "Reset (#{changed}) #{instruction}"
        init(pos)
      end
    end
  end
end
