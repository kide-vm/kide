module Risc

  # BinaryCodes form a linked list
  #
  # We want to keep all code for a method continous, so we propagate Positions
  #
  # At the end of the list the propagation spills into the next methods
  # binary and so on
  #
  class CodeListener

    def set(at)
      raise "Called"
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
    def set_jump_for(position)
      at = position.at
      code = position.object
      jump = Branch.new("BinaryCode #{at.to_s(16)}" , code.next)
      translator = Risc.machine.platform.translator
      cpu_jump = translator.translate(jump)
      pos = at + code.padded_length - cpu_jump.byte_length
      Position.set( cpu_jump , pos , code)
      cpu_jump.assemble(JumpWriter.new(code))
    end

    def position_inserted(position)
      Position.log.debug "extending one in #{self}"
      pos = CodeListener.init( position.object.next )
      pos.set( position + position.object.padded_length)
      return unless position.valid?
      set_jump_for(position)
    end

    def position_changed(position)
      return unless position.object.next
      raise "Called"
    end

    # Create Position for the given BinaryCode object
    # return the first position that was created, to set it
    def self.init( code )
      first = nil
      while code
        raise "Not Binary Code #{code.class}" unless code.is_a?(Parfait::BinaryCode)
        position = Position.new(code , -1)
        first = position unless first
        position.position_listener(CodeListener.new)
        code = code.next
      end
      first
    end
  end
end
