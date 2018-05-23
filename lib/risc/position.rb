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
    log_level :debug

    @positions = {}

    def self.positions
      @positions
    end

    def self.at( int )
      self.positions.each do |object , position|
        next unless position.at == int
        return position unless position.is_a?(InstructionPosition)
        return position unless position.instruction.is_a?(Label)
      end
      nil
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

    # set to the same position as before, thus triggering whatever code that propagates
    # position _must have been set, otherwise raises
    def self.reset(obj)
      old = self.get(obj)
      old.reset_to( old.at )
    end

    def self.set( object , pos , extra = nil)
      # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
      # in measures
      log.debug "Setting #{pos.to_s(16)} for #{object.class}-#{object}"
      old = Position.positions[object]
      testing = self.at( pos )
      if old != nil
        raise "Mismatch was:#{old}#{old.class} , should #{testing}#{testing.class}" if testing and testing.class != old.class
        old.reset_to(pos)
        log.debug "Reset #{pos.to_s(16)} for #{old.class}"
        return old
      end
      position = for_at( object , pos , extra)
      raise "Mismatch was:#{position}#{position.class} , should #{testing}#{testing.class}" if testing and testing.class != old.class
      self.positions[object] = position
      position.init(pos)
      log.debug "Set #{pos.to_s(16)} for #{position.class}"
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
