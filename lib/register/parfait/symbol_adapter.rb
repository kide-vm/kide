
class Symbol
  include Positioned
  include Padding

  def has_type?
    true
  end
  def get_type
    l = Register.machine.space.classes[:Word].object_type
    #puts "LL #{l.class}"
    l
  end
  def padded_length
    padded to_s.length + 4
  end
  # not the prettiest addition to the game, but it wasn't me who decided symbols are frozen in 2.x
  def cache_positions
    unless defined?(@@symbol_positions)
      @@symbol_positions = {}
    end
    @@symbol_positions
  end
  def position
    pos = cache_positions[self]
    if pos == nil
      str = "position accessed but not set, "
      str += "Machine has object=#{Register.machine.objects.has_key?(self.object_id)} "
      raise str + " for Symbol:#{self}"
    end
    pos
  end
  def position= pos
    # resetting of position used to be error, but since relink and dynamic instruction size it is ok.
    # in measures (of 32)
    old = cache_positions[self]
    if old != nil and ((old - pos).abs > 20000)
      raise "position set again #{pos}!=#{old} for #{self}"
    end
    cache_positions[self] = pos
  end

end
