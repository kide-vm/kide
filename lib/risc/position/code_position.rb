module Risc
  module Position

    # BinaryCodes form a linked list
    #
    # We want to keep all code for a method continous, so we propagate Positions
    #
    # At the end of the list the propagation spills into the next methods
    # binary and so on
    #
    class CodePosition < ObjectPosition

      attr_reader :code , :method

      def initialize(code, pos , method)
        super(pos,code)
        @code = code
        @method = method
        raise "Method nil" unless method
      end
      def init(at)
        next_pos = at + code.padded_length
        if code.next
          Position.set(code.next , next_pos, method)
        else
          next_meth = next_method
          return unless next_meth
          Position.set( next_meth.binary , next_pos , next_meth)
          Position.set( next_meth.cpu_instructions, next_pos + 12 , next_meth.binary)
        end
      end
      def reset_to(pos)
        super(pos)
        #puts "Reset (#{changed}) #{instruction}"
        init(pos)
      end
      def next_method
        next_m = @method.next_method
        return next_m if next_m
        #puts "Type now #{@method.for_type.name}"
        type = next_type(@method.for_type)
        if type
          #puts "Position for #{type.name}"
          return type.methods
        else
          return nil
        end
      end
      def next_type(type)
        nekst = Parfait.object_space.types.next_value(type)
        return nil unless nekst
        return nekst if nekst.methods
        return next_type(nekst)
      end
    end
  end
end
