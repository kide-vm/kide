require "util/eventable"

module Risc
  # Positions are very different during compilation and run-time.
  # At run-time they are inherrent to the object, and fixed.
  # While during compilation we can move things about, and do not use the
  # objects memory position at all.
  #
  # Furthermore, there are differnet kind of positions during compilation.
  # Off course the object position as hinted above, but also instruction
  # positions, that do not reflect the position of the object, but of the
  # assembled instruction in the binary.
  #
  # The Position module keeps a hash of all compile time positions.
  #
  # While the (different)Position objects transmit the change that (re) positioning
  # entails to affected objects.

  class Position
    include Util::Logging
    log_level :info

    include Util::Eventable

    attr_reader :at , :object

    # initialize with a given object, first parameter
    # The object ill be the key in global position map
    # Give an integer as the actual position, where -1
    # which means no legal position known
    def initialize(object , pos )
      @at = pos
      @object = object
      Position.set_to(self , pos)
    end

    # utility to register events of type :position_changed
    # can give an object and a PositionListener will be created for it
    def position_listener(listener)
      unless listener.class.name.include?("Listener")
        listener = PositionListener.new(listener)
      end
      register_event(:position_changed , listener)
    end

    # utility to get all registered listeners to the :position_changed event
    # returns an array
    def position_listeners
      event_table[:position_changed]
    end

    #look for InstructionListener and return its code if found
    def get_code
      listener = event_table.find{|one| one.class == InstructionListener}
      return nil unless listener
      listener.code
    end

    def set(int)
      return int if int == self.at
      Position.set_to(self , int)
      @at = int
      trigger(:position_changed , self )
      int
    end

    def +(offset)
      offset = offset.at if offset.is_a?(Position)
      @at + offset
    end

    def -(offset)
      offset = offset.at if offset.is_a?(Position)
      @at - offset
    end
    def to_s
      "0x#{@at.to_s(16)}"
    end

    def next_slot
      return -1 if at < 0
      self.log.debug "Next Slot @#{at.to_s(16)} for #{object.class} == #{(at + object.byte_length).to_s(16)}"
      at + object.byte_length
    end

    ## class level forward and reverse cache
    @positions = {}
    @reverse_cache = {}

    def self.positions
      @positions
    end

    def self.clear_positions
      @positions = {}
      @reverse_cache = {}
    end

    def self.at( int )
      @reverse_cache[int]
    end

    def self.set?(object)
      self.positions.has_key?(object)
    end

    # get a position from the cache (object -> position)
    # unless it's a label, then get the position of it's next
    def self.get(object)
      pos = self.positions[object]
      if pos == nil
        str = "position accessed but not initialized, "
        str += "0x#{object.object_id.to_s(16)}\n"
        str += "for #{object.class} "
        str += "byte_length #{object.byte_length}" if object.respond_to?(:byte_length)
        str += " for #{object.to_s[0...130]}"
        raise str
      end
      pos
    end

    # populate the position caches (forward and revese) with the given position
    # forward caches object -> position
    # reverse caches position.at > position
    # Labels do not participatein reverse cache
    def self.set_to( position , to)
      postest = Position.positions[position.object] unless to < 0
      raise "Mismatch #{position}" if postest and postest != position
      @reverse_cache.delete(position.at) unless position.object.is_a?(Label)
      testing = self.at( position.at ) unless position.at < 0
      if testing and testing.object.class != position.object.class
        raise "Mismatch (at #{pos.to_s(16)}) was:#{position} #{position.class} #{position.object} , should #{testing}#{testing.class}"
      end
      self.positions[position.object] = position
      @reverse_cache[to] = position unless position.object.is_a?(Label)
      log.debug "Set #{position} (#{to.to_s(16)}) for #{position.object.class} #{position.object.object_id.to_s(16)}"
      position
    end
  end
end
require_relative "position_listener"
require_relative "instruction_listener"
require_relative "code_listener"
