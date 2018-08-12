module Risc

  # BinaryCodes form a linked list
  #
  # We want to keep all code for a method continous, so we propagate Positions
  #
  # At the end of the list the propagation spills into the next methods
  # binary and so on
  #
  class CodeListener

    # need to pass the platform to translate new jumps
    def initialize(platform)
      @platform = Risc::Platform.for(platform)
    end

    def position_inserted(position)
      Position.log.debug "extending one at #{position}"
      pos = CodeListener.init( position.object.next_code , @platform)
      raise "HI #{position}" unless position.valid?
      return unless position.valid?
      Position.log.debug "insert #{position.object.next_code.object_id.to_s(16)}"
      pos.set( position + position.object.padded_length)
      set_jump_for(position)
    end

    def position_changed(position)
      Position.log.debug "Code changed #{position}"
      nekst = position.object.next_code
      if( nekst )
        nekst_pos = Position.get(nekst)
        Position.log.debug "Code changed, setting next #{position}"
        nekst_pos.set(position + position.object.padded_length)
        set_jump_for(position)
      end
    end

    def position_changing(position , to)
      move_along = Position.at( to )
      return unless move_along
      raise "Not BinaryCode at (#{to.to_s(16)}), but is #{move_along.object.class}" unless move_along.object.is_a?(Parfait::BinaryCode)
      move_along.set(move_along + move_along.object.padded_length)
    end

    # insert a jump to the next instruction, at the last instruction
    # thus hopping over the object header
    def set_jump_for(position)
      at = position.at
      code = position.object
      return unless code.next_code #dont jump beyond and
      jump = Branch.new("BinaryCode #{at.to_s(16)}" , code.next_code)
      translator = @platform.translator
      cpu_jump = translator.translate(jump)
      pos = at + code.padded_length - cpu_jump.byte_length
      Position.create(cpu_jump).set(pos)
      cpu_jump.assemble(JumpWriter.new(code))
    end

    # Create Position for the given BinaryCode object
    # second param is the platform, needed to translate new jumps
    # return the first position that was created, to set it
    def self.init( code , platform)
      first = nil
      while code
        raise "Not Binary Code #{code.class}" unless code.is_a?(Parfait::BinaryCode)
        position = Position.get_or_create(code)
        first = position unless first
        position.position_listener(CodeListener.new(platform))
        code = code.next_code
      end
      first
    end
  end
end
