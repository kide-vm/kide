# Helper module that extract position attribute.
module Positioned
  @positions = {}

  def self.positions
    @positions
  end

  def self.position(object)
    pos = self.positions[object]
    if pos == nil
      str = "position accessed but not set, "
      str += "0x#{object.object_id.to_s(16)}\n"
      str += "for #{object.class} byte_length #{object.byte_length if object.respond_to?(:byte_length)} for #{object.inspect[0...100]}"
      raise str
    end
    pos
  end

  def self.set_position( object , pos )
    raise "Position must be number not :#{pos}:" unless pos.is_a?(Numeric)
    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures (of 32)
    #puts "Setting #{pos} for #{self.class}"
    old = Positioned.positions[object]
    if old != nil and ((old - pos).abs > 10000)
      raise "position set again #{pos}!=#{old} for #{object}"
    end
    self.positions[object] = pos
  end


end
