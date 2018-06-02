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
        str += "for #{object.class} "
        str += "byte_length #{object.byte_length}" if object.respond_to?(:byte_length)
        str += " for #{object.to_s[0...130]}"
        raise str
      end
      pos
    end

    def self.reset(obj)
      old = self.get(obj)
      old.reset_to( old.at )
    end

    def self.set_to( position , to)
      postest = Position.positions[position.object]
      raise "Mismatch #{position}" if postest and postest != position
      @reverse_cache.delete(position.at) unless position.object.is_a? Label
      testing = self.at( position.at ) if position.at >= 0
      if testing and testing.class != position.class
        raise "Mismatch (at #{pos.to_s(16)}) was:#{position} #{position.class} #{position.object} , should #{testing}#{testing.class}"
      end
      self.positions[position.object] = position
      @reverse_cache[to] = position unless position.object.is_a? Label
      log.debug "Set #{position} (#{to.to_s(16)}) for #{position.class}"
      position
    end
  end
end
require_relative "object_position"
require_relative "object_listener"
require_relative "instruction_position"
require_relative "code_listener"
