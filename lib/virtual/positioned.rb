require_relative "type"

module Positioned
  def position
    if @position == nil
      raise "position accessed but not set at #{word_length} for #{self.inspect[0...500]}"
    end
    @position
  end
  def set_position pos
    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures (of 32)
    if @position != nil and ((@position - pos).abs > 32)
      raise "position set again #{pos}!=#{@position} for #{self}"
    end
    @position = pos
  end

end
