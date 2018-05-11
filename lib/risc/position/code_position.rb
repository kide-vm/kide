module Risc
  module Position

    # BinaryCodes form a linked list
    #
    # We want to keep all code for a method continous, so we propagate Positions
    #
    class CodePosition < ObjectPosition

      attr_reader :code , :method

      def initialize(code, pos , method)
        super(pos,code)
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
