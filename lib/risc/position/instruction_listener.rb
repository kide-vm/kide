module Risc
  # Instructions are also a linked list, but their position is not really
  # the position of the object.
  # Rather it is the position of the assembled code in the binary.
  # (Luckily arm is sane, so this is relatively simple)
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
    attr_reader :binary , :index

    def initialize(binary)
      @binary = binary
      @index = -1
    end

    # if the position of the instruction changes, we need to adjust the position
    # of the next instruction accordingly (if present)
    # Taking into account that BinaryCodes only take 13 instructions,
    # meaning that chain may have to be extended
    def position_changing(position , to)
      Position.log.debug "Changing #{position} to 0x#{to.to_s(16)}, bin #{Position.get(@binary)}"
      update_index(to)
      instruction = position.object
      return unless instruction.next
      if @index == (Parfait::BinaryCode.data_length - 1 ) and !instruction.is_a?(Label)
        nekst_pos_diff = @binary.padded_length
      else
        nekst_pos_diff = @index * 4 + instruction.byte_length
      end
      Position.log.debug "Nekst + #{nekst_pos_diff + Parfait::BinaryCode.byte_offset}"
      nekst = Position.get(position.object.next)
      nekst.set(Position.get(@binary) + nekst_pos_diff + Parfait::BinaryCode.byte_offset)
    end

    def update_index(to)
      index = (to - Position.get(@binary).at) / 4
      raise "Invalid negative index #{index} ,  #{Position.get(@binary)}" if index < Parfait::BinaryCode.type_length
      while(index >= (Parfait::BinaryCode.memory_size - 1) )
        @binary = @binary.ensure_next
        index = (to - Position.get(@binary).at) / 4
      end
      @index = index - 2
      raise "Invalid negative index #{@index} ,  #{Position.get(@binary)}" if index < 0
    end

    # update label positions. All else done in position_changing
    def position_changed(position)
      instruction = position.object
      return unless instruction.is_a?(Label)
      instruction.address.set_value(position.at)
    end

    # When this is called, only the actual insert has happened (keeping the
    # position logic out of the instruction assembly).
    #
    # This event happens at the listener of the positionwhere the insert happens, ie:
    # position : the arg is the first instruction in the chain where insert happened
    # position.object.next : is the newly inserted instruction we need to setup
    #
    # So we need to :
    # - add a listener for the new instruction (to listen to the arg)
    # - trigger change for this (fake) to set position of inserted
    def position_inserted(position)
      inserted = position.object.next
      new_pos = Position.new(inserted , -1)
      new_pos.position_listener(InstructionListener.new(@binary))

      position.trigger_changing(position.at)
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
        il = InstructionListener.new( code )
        position.position_listener(il)
        if instruction.respond_to?(:branch)
#          label_pos = Position.get(instruction.branch)
#          label_pos.position_listener( BranchListener.new(il)) 
        end
        instruction = instruction.next
      end
      first
    end
  end
end
