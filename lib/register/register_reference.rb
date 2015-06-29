module Register

  # RegisterReference is not the name for a register, "only" for a certain use of it.
  # In a way it is like a variable name, a storage location. The location is a register off course,
  # but which register can be changed, and _all_ instructions sharing the RegisterReference then
  # use that register
  # In other words a simple level of indirection, or change from value to reference sematics.

  class RegisterReference

    attr_accessor :symbol

    def initialize r
      raise "wrong type for register init #{r}" unless r.is_a? Symbol
      raise "double r #{r}" if r.to_s[0,1] == "rr"
      raise "not reg #{r}" unless self.class.look_like_reg r
      @symbol = r
    end

    def self.convert something
      return something unless something.is_a? Symbol
      return something unless look_like_reg(something)
      return new(something)
    end

    def self.look_like_reg is_it
      return true if is_it.is_a? RegisterReference
      return false unless is_it.is_a? Symbol
      if( [:lr , :pc].include? is_it )
        return true
      end
      if( (is_it.to_s.length < 3) and (is_it.to_s[0] == "r"))
        # could tighten this by checking that the rest is a number
        return true
      end
      return false
    end

    def == other
      return false if other.nil?
      return false if other.class != RegisterReference
      symbol == other.symbol
    end

    #helper method to calculate with register symbols
    def next_reg_use by = 1
      int = @symbol[1,3].to_i
      sym = "r#{int + by}".to_sym
      RegisterReference.new( sym )
    end

    def sof_reference_name
      @symbol
    end

  end

  MESSAGE_REGISTER = :r0
  SELF_REGISTER = :r1
  FRAME_REGISTER = :r2
  NEW_MESSAGE_REGISTER = :r3

  TMP_REGISTER = :r4

  def self.self_reg
    RegisterReference.new SELF_REGISTER
  end
  def self.message_reg
    RegisterReference.new MESSAGE_REGISTER
  end
  def self.frame_reg
    RegisterReference.new FRAME_REGISTER
  end
  def self.new_message_reg
    RegisterReference.new NEW_MESSAGE_REGISTER
  end
  def self.tmp_reg
    RegisterReference.new TMP_REGISTER
  end

  def self.get_slot from , index , to
    index = resolve_index( from , index)
    from = resolve_to_register from
    to = resolve_to_register to
    GetSlot.new( from , index , to)
  end

  def self.set_slot from , to , index
    index = resolve_index( to , index)
    from = resolve_to_register from
    to = resolve_to_register to
    SetSlot.new( from , to , index)
  end

  def self.save_return from , index
    index = resolve_index( from , index)
    from = resolve_to_register from
    SaveReturn.new( from , index )
  end

  def self.resolve_index( clazz_name , instance_name )
    return instance_name unless instance_name.is_a? Symbol
    real_name = clazz_name.to_s.split('_').last.capitalize.to_sym
    clazz = Parfait::Space.object_space.get_class_by_name(real_name)
    raise "Class name not given #{real_name}" unless clazz
    index = clazz.object_layout.index_of( instance_name )
    raise "Instance name=#{instance_name} not found on #{real_name}" unless index.is_a?(Numeric)
    return index
  end

  def self.resolve_to_register reference
    register = reference
    if reference.is_a? Symbol
      case reference
      when :message
        register = message_reg
      when :new_message
        register = new_message_reg
      when :self
        register = self_reg
      when :frame
        register = frame_reg
      else
        raise "not recognized register reference #{reference}"
      end
    end
    return register
  end
end
