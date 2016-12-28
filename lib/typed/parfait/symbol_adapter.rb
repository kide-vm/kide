
class Symbol
  include Positioned
  include Padding

  def has_type?
    true
  end
  def get_type
    l = Register.machine.space.classes[:Word].instance_type
    #puts "LL #{l.class}"
    l
  end
  def padded_length
    padded to_s.length + 4
  end

end
