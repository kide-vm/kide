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

    INVALID = -1

    include Util::Eventable

    attr_reader :at , :object

    # initialize with a given object, first parameter
    # The object will be the key in global position map
    #
    # The actual position starts as -1 (invalid)
    def initialize(object)
      @at = INVALID
      @object = object
    end

    # utility to register events of type :position_changed
    # can give an object and a PositionListener will be created for it
    def position_listener(listener)
      unless listener.class.name.include?("Listener")
        listener = PositionListener.new(listener)
      end
      register_event(:position_changed , listener)
    end

    # When instruction get inserted, we have to move listeners around, remove given
    def remove_position_listener(list)
      unregister_event(:position_changed, list)
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

    def valid?
      @at != INVALID
    end

    def set(int)
      return int if int == self.at
      trigger_changing( int )
      Position.set_cache(self , int)
      @at = int
      trigger_changed
      self
    end

    # helper to fire the event that the position is about to change
    # the argument is the new position (as int)
    def trigger_changing( to )
      event_table[:position_changed].each { |handler| handler.position_changing( self , to) }
    end

    # helper to fire the event that the position has changed
    # Note: set checks if the position actually has changed, before fireing
    #     but during insert it is helpful to trigger just to set the next
    def trigger_changed
      trigger(:position_changed , self )
    end

    def trigger_inserted
      event_table[:position_changed].each { |handler| handler.position_inserted( self) }
    end

    def +(offset)
      offset = offset.at if offset.is_a?(Position)
      @at + offset
    end

    def -(offset)
      offset = offset.at if offset.is_a?(Position)
      @at - offset
    end

    def <(right)
      right = right.at if right.is_a?(Position)
      @at < right
    end

    def >(right)
      right = right.at if right.is_a?(Position)
      @at > right
    end

    def to_s
      "0x#{@at.to_s(16)}"
    end

    def object_class
      return :object if @object.is_a?(Parfait::Object)
      return :object if @object.class.name.include?("Test")
      :instruction
    end

    def next_slot
      return -1 if at < 0
      slot = at + object.padded_length
      self.log.debug "Next Slot @#{at.to_s(16)} for #{object.class}(#{object.padded_length.to_s(16)}) == #{(slot).to_s(16)}"
      slot
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
      self.positions[object]
    end

    # get a position from the cache (object -> position)
    # unless it's a label, then get the position of it's next
    def self.get(object)
      pos = self.positions[object]
      if pos == nil
        str = "position accessed but not initialized, "
        str += "0x#{object.object_id.to_s(16)}\n"
        str += "class: #{object.class} "
        str += "byte_length #{object.byte_length}" if object.respond_to?(:byte_length)
        str += " object: #{object.to_s[0...130]}"
        raise str
      end
      pos
    end

    # creating means instantiating and caching
    def self.create(object)
      pos = Position.new(object)
      self.positions[object] = pos
      log.debug "Initialize for #{object.class} #{object.object_id.to_s(16)}"
      pos
    end

    def self.get_or_create(object)
      if self.positions.has_key?(object)
        pos = self.get(object)
      else
        pos = self.create(object)
      end
      return pos
    end

    # populate the position caches (forward and revese) with the given position
    # forward caches object -> position
    # reverse caches position.at > position
    # Labels do not participatein reverse cache
    def self.set_cache( position , to)
      postest = Position.positions[position.object] unless to < 0
      raise "Mismatch #{position}" if postest and postest != position
      @reverse_cache.delete(position.at) unless position.object.is_a?(Label)
      testing = self.at( position.at ) unless position.at < 0
      if testing and testing.object_class != position.object_class
        raise "Mismatch (at #{to.to_s(16)}) new:#{position} #{position.object.class} , was:#{testing}#{testing.object.class}"
      end
      self.positions[position.object] = position
      @reverse_cache[to] = position unless position.object.is_a?(Label)
      if to == INVALID
        raise "Old style, change code"
      else
        log.debug "Set #{position} to 0x#{to.to_s(16)} for #{position.object.class} #{position.object.object_id.to_s(16)}"
      end
      position
    end

    def self.is_object(object)
      case object
      when Risc::Label , Parfait::BinaryCode
        return false
      when Parfait::Object , Symbol
        return true
      when Arm::Instruction , Risc::Branch
        return false
      else
        raise "Class #{object.class}"
      end
    end
  end
end
require_relative "position_listener"
require_relative "instruction_listener"
require_relative "branch_listener"
require_relative "code_listener"
require_relative "label_listener"
