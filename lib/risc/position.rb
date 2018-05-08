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
    # just a callback after creation AND insertion
    def init(pos)
    end
    def reset_to(pos)
      return false if pos == at
      if((at - pos).abs > 1000)
        raise "position set too far off #{pos}!=#{at} for #{object}:#{object.class}"
      end
      @at = pos
      true
    end

    def self.positions
      @positions
    end

    def self.set?(object)
      self.positions.has_key?(object)
    end

    def self.get(object)
      pos = self.positions[object]
      if pos == nil
        str = "position accessed but not set, "
        str += "0x#{object.object_id.to_s(16)}\n"
        str += "for #{object.class} byte_length #{object.byte_length if object.respond_to?(:byte_length)} for #{object.inspect[0...130]}"
        raise str
      end
      pos
    end

    def self.set( object , pos , extra = nil)
      # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
      # in measures (of 32)
      #puts "Setting #{pos} for #{self.class}"
      old = Position.positions[object]
      if old != nil
        old.reset_to(pos)
        return old
      end
      position = for_at( object , pos , extra)
      self.positions[object] = position
      position.init(pos)
      position
    end

    def self.for_at(object , at , extra)
      case object
      when Parfait::BinaryCode
        BPosition.new(object,at , extra)
      when Arm::Instruction , Risc::Label
        IPosition.new(object,at , extra)
      else
        Position.new(at)
      end
    end
  end
  # handle event propagation
  class IPosition < Position
    attr_reader :instruction , :binary
    def initialize(instruction, pos , binary)
      raise "not set " unless binary
      super(pos)
      @instruction = instruction
      @binary = binary
    end

    def init(at)
      return unless instruction.next
      at += instruction.byte_length
      bin = binary
      if( 12 == at % 60)
        at = 12
        bin = binary.next
      end
      Position.set(instruction.next, at , binary)
    end

    def reset_to(pos)
      changed = super(pos)
      #puts "Reset (#{changed}) #{instruction}"
      return unless changed
      return unless instruction.next
      instruction.next.set_position( pos + instruction.byte_length , 0)
    end

  end
  class BPosition < Position
    attr_reader :code , :method
    def initialize(code, pos , method)
      super(pos)
      @code = code
      @method = method
    end
    def init(at)
      return unless code.next
      Position.set(code.next , at + code.padded_length, method)
    end
  end
end
