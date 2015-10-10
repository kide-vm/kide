#require_relative "type"

module Positioned
  def position
    if @position.nil?
      str = "IN machine #{Virtual.machine.objects.has_key?(self.object_id)}, at #{self.object_id.to_s(16)}\n"
      raise str + "position not set for #{self.class} len #{word_length} for #{self.inspect[0...100]}"
    end
    @position
  end
  def set_position pos
    raise "Setting of nil not allowed" if pos.nil?
    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures (of 32)
    if @position != nil and ((@position - pos).abs > 32)
      raise "position set again #{pos}!=#{@position} for #{self}"
    end
    @position = pos
  end
end
