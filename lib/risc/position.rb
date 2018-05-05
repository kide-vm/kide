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
  # The Position class keeps a hash of all compile time positions.
  #
  # While the Position objects transmit the change that (re) positioning
  # entails to affected objects.

  class Position
    @positions = {}

    attr_reader :at

    def initialize( at )
      @at = at
      raise "not int #{self}-#{at}" unless @at.is_a?(Integer)
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

    def self.positions
      @positions
    end

    def self.position(object)
      pos = self.positions[object]
      if pos == nil
        str = "position accessed but not set, "
        str += "0x#{object.object_id.to_s(16)}\n"
        str += "for #{object.class} byte_length #{object.byte_length if object.respond_to?(:byte_length)} for #{object.inspect[0...130]}"
        raise str
      end
      pos
    end

    def self.set_position( object , pos )
      # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
      # in measures (of 32)
      #puts "Setting #{pos} for #{self.class}"
      old = Position.positions[object]
      if old != nil and ((old - pos).abs > 1000)
        raise "position set too far off #{pos}!=#{old} for #{object}:#{object.class}"
      end
      self.positions[object] = Position.new( pos )
    end
  end
end
