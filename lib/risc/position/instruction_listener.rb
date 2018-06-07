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

    # if the position of the instruction before us changes, we need to
    # adjust the position of this instruction accordingly
    # Taking into account that BinaryCodes only take 13 instructions,
    # meaning that chain may have to be extended
    def position_changed(position)
      next_pos = position.at + position.object.byte_length
      fix_binary_for(next_pos)
      my_pos = Position.get(@instruction)
      diff = next_pos - Position.get(@binary).at
      Position.log.debug "Diff: 0x#{diff.to_s(16)} , next 0x#{next_pos.to_s(16)} , binary #{Position.get(@binary)}"
      raise "Invalid position #{diff.to_s(16)} , next #{next_pos.to_s(16)} #{position}" if diff < 8
      if( (diff % (@binary.padded_length - @instruction.byte_length)) == 0 )
        @binary = @binary.ensure_next
        next_pos = Position.get(@binary).at + Parfait::BinaryCode.byte_offset
        #Insert/Position the jump (its missing)
        Position.log.debug "Jump to: #{next_pos.to_s(16)}"
      end
      my_pos.set(next_pos)
    end

    # When this is called, only the actual insert has happened (keeping the
    # position logic out of the instruction assembly).
    #
    # This event happens at the listener that was dependent on the position
    # before the insert, ie:
    # position : the arg is the first instruction in the chain where insert happened
    # position.object.next : is the newly inserted instruction we need to setup
    # @instruction : previously dependent on position, now on inserted's position
    #
    # So we need to :
    # - move the listener self to listen to the inserted instruction
    # - add a listener for the new instruction (to listen to the arg)
    # - set the new position (moving the chain along)
    def position_inserted(position)
      inserted = position.object.next
      raise "uups" unless inserted ## TODO: remove
      position.remove_position_listener(self)
      new_pos = Position.new(inserted , -1)
      new_pos.position_listener(self)

      listen = InstructionListener.new(inserted , @binary)
      position.position_listener(listen)

      position.trigger_changed
    end

    # check that the binary we use is the one where the current position falls
    # if not move up and register/unregister (soon)
    #
    # Because the position for the @instruction may not be set yet,
    # we use the one that it will be set to (the arg)
    def fix_binary_for(new_pos)
      raise "Binary has no position (-1)" if Position.get(@binary).at == -1
      count = 0
      bin_pos = Position.get(@binary)
      while( !pos_in_binary(new_pos))
        @binary = @binary.ensure_next
        count += 1
        raise "Positions too far out (#{count}) #{Position.get(@instruction)}:#{bin_pos}" if count > 5
      end
    end

    # check if the given position is inside the @binary
    # ie not below start or above end
    def pos_in_binary(new_pos)
      bin = Position.get(@binary)
      return false if bin > new_pos
      return false if new_pos > (bin + @binary.padded_length)
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
