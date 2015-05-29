require_relative "type"

module Positioned
  def position
    raise "position accessed but not set at #{mem_length} for #{self.inspect[0...500]}" if @position == nil
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
  # objects only come in lengths of multiple of 8 words
  # but there is a constant overhead of 2 words, one for type, one for layout
  # and as we would have to subtract 1 to make it work without overhead, we now have to add 7
  def padded len
    a = 32 * (1 + (len + 7)/32 )
    #puts "#{a} for #{len}"
    a
  end

  def padded_words words
    padded(words*4) # 4 == word length, a constant waiting for a home
  end
end
