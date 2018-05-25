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

  module Position
    include Util::Logging
    log_level :info

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

    def self.get(object)
      pos = self.positions[object]
      if pos == nil
        str = "position accessed but not set, "
        str += "0x#{object.object_id.to_s(16)}\n"
        str += "for #{object.class} byte_length #{object.byte_length if object.respond_to?(:byte_length)} for #{object.to_s[0...130]}"
        raise str
      end
      pos
    end

    def self.reset(obj)
      old = self.get(obj)
      old.reset_to( old.at )
    end

    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures
    #
    # reseting to the same position as before, triggers code that propagates
    def self.reset(position , to , extra)
      log.debug "ReSetting #{position}, to:#{to.to_s(16)}, for #{position.object.class}-#{position.object}"
      position.reset_to(to, extra)
      if testing = @reverse_cache[ to ]
        if testing.class != position.class
          raise "Mismatch (at #{to.to_s(16)}) new:#{position}:#{position.class} , was #{testing}:#{testing.class}"
        end
      end
      unless position.object.is_a? Label
        @reverse_cache.delete(to)
        @reverse_cache[position.at] = position
      end
      log.debug "Reset #{position} (#{to.to_s(16)}) for #{position.class}"
      return position
    end

    def self.set( object , pos , extra = nil)
      old = Position.positions[object]
      return self.reset(old , pos , extra) if old
      log.debug "Setting #{pos.to_s(16)} for #{object.class}-#{object}"
      testing = self.at( pos )
      position = for_at( object , pos , extra)
      raise "Mismatch (at #{pos.to_s(16)}) was:#{position} #{position.class} #{position.object} , should #{testing}#{testing.class}" if testing and testing.class != position.class
      self.positions[object] = position
      position.init(pos , extra)
      @reverse_cache[position.at] = position unless object.is_a? Label
      log.debug "Set #{position} (#{pos.to_s(16)}) for #{position.class}"
      position
    end

    def self.for_at(object , at , extra)
      case object
      when Parfait::BinaryCode
        CodePosition.new(object,at , extra)
      when Arm::Instruction , Risc::Instruction
        InstructionPosition.new(object,at , extra)
      else
        ObjectPosition.new(object,at)
      end
    end
  end
end
require_relative "position/object_position"
require_relative "position/instruction_position"
require_relative "position/code_position"
