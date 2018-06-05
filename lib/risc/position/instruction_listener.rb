module Risc
  # Instructions are also a linked list, but their position is not really
  # the position of the object.
  # Rather it is the position of the assembled code in the binary.
  # (Luckily arm is sane, so this is realtively simple)
  #
  # Really we only need to calculate Positions at a jump, so between the
  # Jump and the label it jumps too. The other instructions are "just" fill.
  # But off course we need to propagate positions to get it right.
  #
  # Assembled instructions are kept in BinaryCode objects.
  # When propagating positions we have to see that the next position assembles into
  # the same BinaryCode, or else move it and the code along
  #
  class InstructionListener
    attr_reader :instruction , :binary
    def initialize(instruction , binary)
      @instruction = instruction
      @binary = binary
    end

    def position_changed(position)
      fix_binary
      my_pos = Position.get(@instruction)
      next_pos = position.at + position.object.byte_length
      diff = next_pos - Position.get(@binary).at
      Position.log.debug "Diff: #{diff.to_s(16)} , next #{next_pos.to_s(16)} , binary #{Position.get(@binary)}"
      raise "Invalid position #{diff.to_s(16)} , next #{next_pos.to_s(16)} #{position}" if diff < 8
      if( (diff % (@binary.padded_length - @instruction.byte_length)) == 0 )
        @binary = @binary.ensure_next
        next_pos = Position.get(@binary).at + Parfait::BinaryCode.byte_offset
        Position.log.debug "Jump to: #{next_pos.to_s(16)}"
      end
      my_pos.set(next_pos)
    end

    # check that the binary we use is the one where the current position falls
    # if not move up and register/unregister (soon)
    def fix_binary
      raise "Binary has no position (-1)" if Position.get(@binary).at == -1
      return if Position.get(@instruction).at == -1
      count = 0
      org_pos = Position.get(@binary)
      return if org_pos.at == -1
      while( !pos_in_binary)
        @binary = @binary.ensure_next
        count += 1
        raise "Positions messed #{Position.get(@instruction)}:#{org_pos}"
      end
    end

    def pos_in_binary
      me = Position.get(@instruction)
      bin = Position.get(@binary)
      return false if me < bin
      return false if me > (bin + @binary.padded_length)
      return true
    end

    # initialize the dependency graph for instructions
    #
    # starting from the given instruction, create Positions
    # for it and the whole chain. Then attach InstructionListeners
    # for dependency tracking. All positions are initialized with -1
    # and so setting the first will trigger a chain reaction
    #
    # return the position for the first instruction which may be used to
    # set all positions in the chain
    def self.init( instruction , code )
      raise "Not Binary Code #{code.class}" unless code.is_a?(Parfait::BinaryCode)
      raise "Must init with instruction, not nil" unless instruction
      first = nil
      while(instruction)
        position = Position.new(instruction , -1)
        first = position unless first
        nekst = instruction.next
        if nekst
          listener = InstructionListener.new( nekst , code )
          position.position_listener(listener)
        end
        instruction = nekst
      end
      first
    end
  end
end
