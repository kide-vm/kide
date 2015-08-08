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

    def to_s
      symbol.to_s
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
      if( (is_it.to_s.length <= 3) and (is_it.to_s[0] == "r"))
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

  # Here we define the mapping from virtual machine objects, to register machine registers
  #

  # The register we use to store the current message object is :r0
  def self.message_reg
    RegisterReference.new :r0
  end

  # A register to hold the receiver of the current message, in oo terms the self. :r1
  def self.self_reg
    RegisterReference.new :r1
  end

  # The register to hold a possible frame of the currently executing method. :r2
  # May be nil if the method has no local variables
  def self.frame_reg
    RegisterReference.new :r2
  end

  # The register we use to store the new message object is :r3
  # The new message is the one being built, to be sent
  def self.new_message_reg
    RegisterReference.new :r3
  end

  # The first scratch register. There is a next_reg_use to get a next and next.
  # Current thinking is that scratch is schatch between instructions
  def self.tmp_reg
    RegisterReference.new :r4
  end

  # The first arg is a class name (possibly lowercase) and the second an instance variable name.
  # By looking up the class and the layout for that class, we can resolve the instance
  # variable name to an index.
  # The class can be mapped to a register, and so we get a memory address (reg+index)
  def self.resolve_index( clazz_name , instance_name )
    return instance_name unless instance_name.is_a? Symbol
    real_name = clazz_name.to_s.split('_').last.capitalize.to_sym
    clazz = Parfait::Space.object_space.get_class_by_name(real_name)
    raise "Class name not given #{real_name}" unless clazz
    index = clazz.object_layout.variable_index( instance_name )
    raise "Instance name=#{instance_name} not found on #{real_name}" unless index.is_a?(Numeric)
    return index #  the type word is at index 0, but layout is a list and starts at 1 == layout
  end

  # if a symbol is given, it may be one of the four objects that the vm knows.
  # These are mapped to register references.
  # The valid symbols (:message, :self,:frame,:new_message) are the same that are returned
  # by the slots. All data (at any time) is in one of the instance variables of these four
  # objects. Register defines module methods with the same names (and _reg)
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

  # when knowing the index of the argument, return the index into the message
  # index passed is parfait, ie stats at 1
  def self.arg_index i
    last = resolve_index :message , :name
    return last + i
  end
end
