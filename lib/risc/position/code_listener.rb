module Risc

  # BinaryCodes form a linked list
  #
  # We want to keep all code for a method continous, so we propagate Positions
  #
  # At the end of the list the propagation spills into the next methods
  # binary and so on
  #
  class CodeListener

    attr_reader :code , :method

    def initialize(code , method)
      super(code,pos)
      @code = code
      @method = method
      raise "Method nil" unless method
    end
    def set(at )
      next_pos = at + code.padded_length
      if code.next
        Position.set(code.next , next_pos, method)
        set_jump(at)
      else
        next_meth = next_method
        return unless next_meth
        Position.set( next_meth.binary , next_pos , next_meth)
        next_cpu_pos = next_pos + Parfait::BinaryCode.byte_offset
        Position.set( next_meth.cpu_instructions, next_cpu_pos , next_meth.binary)
      end
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

    def self.init( code , at = -1)
      while code
        position = Position.new(code , at)
        Position.set_to(position , at)
        if code.next
          listener = PositionListener.new(code.next)
          position.position_listener( listener)
        end
        at += code.padded_length unless at < 0
        code = code.next
      end
      position
    end
  end
end
