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
        super(code,pos)
        @code = code
        @method = method
        raise "Method nil" unless method
      end
      def init(at , method)
        raise "No no" unless method.name == @method.name
        next_pos = at + code.padded_length
        if code.next
          Position.set(code.next , next_pos, method)
          set_jump(at)
        else
          next_meth = next_method
          return unless next_meth
          Position.set( next_meth.binary , next_pos , next_meth)
          next_cpu_pos = next_pos + Parfait::BinaryCode.offset
          Position.set( next_meth.cpu_instructions, next_cpu_pos , next_meth.binary)
        end
      end
      def reset_to(pos , ignored)
        super(pos, ignored)
        init(pos , ignored)
        Position.log.debug "ResetCode (#{pos.to_s(16)}) #{code}"
      end
      # insert a jump to the next instruction, at the last instruction
      # thus hopping over the object header
      def set_jump(at)
        jump = Branch.new("BinaryCode #{at.to_s(16)}" , code.next)
        translator = Risc.machine.platform.translator
        cpu_jump = translator.translate(jump)
        pos = at + code.padded_length - cpu_jump.byte_length
        Position.set( cpu_jump , pos , code)
        cpu_jump.assemble(JumpWriter.new(code))
      end

      def next_method
        next_m = @method.next_method
        return next_m if next_m
        Position.log.debug "Type now #{@method.for_type.name}"
        type = next_type(@method.for_type)
        if type
          Position.log.debug "Position for #{type.name}"
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
